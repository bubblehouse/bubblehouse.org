# encoding: utf-8

require 'octokit'
require "net/https"
require 'uri'

module Jekyll

  class GistPost < Post
    def initialize(site, source, gist)
      date_slug = gist[:created_at].strftime("%Y-%m-%d-")
      name_slug = gist[:description].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      
      @name = date_slug + name_slug + '.md'
      @site = site
      @base = source
      @dir = '.'
      
      self.data = {
        "title" =>  "#{gist[:description]}",
        "layout" => "page",
        "created" => gist[:created_at].to_i
      }
      
      self.content = gist[:files].to_attrs.keys.collect { |key|
        uri = URI.parse(gist[:files][key][:raw_url])
        
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        
        language = (gist[:files][key][:language] || '').downcase
        language = (language == 'shell' ? 'bash' : language)
        
        s = ''
        if(language != 'markdown')
          s << "\n```#{language}\n"
        end
        s << response.body.force_encoding('utf-8')
        if(language != 'markdown')
          s << "\n```\n"
        end
        "#{s}\n[#{key}](#{gist[:html_url]}) hosted by [GitHub](https://github.com)"
      }.join("\n\n")

      self.slug = gist[:description].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      self.ext = '.md'
      self.date = gist[:created_at]
      self.categories = ['gist', 'coding']
      self.tags = []
      self.extracted_excerpt = extract_excerpt
    end
  end

  class GistPageGenerator < Generator
    safe true

    def generate(site)
      client = Octokit::Client.new \
        :access_token => "2b670ab076cf7b4a6eb830e3388fa445a2a5b16e"
      
      client.user('philchristensen').rels[:gists].get.data.each do |gist|
        if(gist[:public])
          post = GistPost.new(site, site.source, gist)
          site.posts << post
        end
      end
      site.posts.sort! { |a,b| a.date <=> b.date }
    end
  end

end

# A Liquid tag for Jekyll sites that allows embedding Gists and showing code for non-JavaScript enabled browsers and readers.
# by: Brandon Tilly
# Source URL: https://gist.github.com/1027674
# Post http://brandontilley.com/2011/01/31/gist-tag-for-jekyll.html
#
# Example usage: {% gist 1027674 gist_tag.rb %} //embeds a gist for this plugin

require 'cgi'
require 'digest/md5'
require 'net/https'
require 'uri'

module Jekyll
  class GistTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text           = text
      @cache_disabled = false
      @cache_folder   = File.expand_path "../_gist_cache", File.dirname(__FILE__)
      FileUtils.mkdir_p @cache_folder
    end

    def render(context)
      if parts = @text.match(/([\d]*) (.*)/)
        gist, file = parts[1].strip, parts[2].strip
        script_url = script_url_for gist, file
        code       = get_cached_gist(gist, file) || get_gist_from_web(gist, file)
        html_output_for script_url, code
      else
        ""
      end
    end

    def html_output_for(script_url, code)
      code = CGI.escapeHTML code
      <<-HTML
<div><script src='#{script_url}'></script>
<noscript><pre><code>#{code}</code></pre></noscript></div>
      HTML
    end

    def script_url_for(gist_id, filename)
      "https://gist.github.com/#{gist_id}.js?file=#{filename}"
    end

    def get_gist_url_for(gist, file)
      "https://raw.github.com/gist/#{gist}/#{file}"
    end

    def cache(gist, file, data)
      cache_file = get_cache_file_for gist, file
      File.open(cache_file, "w") do |io|
        io.write data
      end
    end

    def get_cached_gist(gist, file)
      return nil if @cache_disabled
      cache_file = get_cache_file_for gist, file
      File.read cache_file if File.exist? cache_file
    end

    def get_cache_file_for(gist, file)
      bad_chars = /[^a-zA-Z0-9\-_.]/
      gist      = gist.gsub bad_chars, ''
      file      = file.gsub bad_chars, ''
      md5       = Digest::MD5.hexdigest "#{gist}-#{file}"
      File.join @cache_folder, "#{gist}-#{file}-#{md5}.cache"
    end

    def get_gist_from_web(gist, file)
      gist_url          = get_gist_url_for gist, file
      raw_uri           = URI.parse gist_url
      https             = Net::HTTP.new raw_uri.host, raw_uri.port
      https.use_ssl     = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request           = Net::HTTP::Get.new raw_uri.request_uri
      data              = https.request request
      data              = data.body
      cache gist, file, data unless @cache_disabled
      data
    end
  end

  class GistTagNoCache < GistTag
    def initialize(tag_name, text, token)
      super
      @cache_disabled = true
    end
  end
end

Liquid::Template.register_tag('gist', Jekyll::GistTag)
Liquid::Template.register_tag('gistnocache', Jekyll::GistTagNoCache)