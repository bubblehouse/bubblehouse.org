require 'octokit'

module Jekyll

  class ActiveReposGenerator < Generator
    safe true

    def generate(site)
      client = Octokit::Client.new \
        :access_token => "2b670ab076cf7b4a6eb830e3388fa445a2a5b16e"
      
      output = []
      path = File.join(site.source, '_includes/generated/active_repos')
      f = File.open(path, 'w')
      data = client.repositories('philchristensen', :sort => 'pushed', :direction => 'desc')
      data[0..9].each do |repo|
        f.write("          <li>
                  <div class=\"repo\">
                    <small class=\"language #{(repo[:language]||'').downcase}\">#{repo[:language]}</small>
                    <a class=\"name\" href=\"#{repo[:html_url]}\">#{repo[:name]}</a>
                  </div>
                </li>")
      end
      f.close()
    end
  end
  
  class PopularReposGenerator < Generator
    safe true

    def generate(site)
      client = Octokit::Client.new \
        :access_token => "2b670ab076cf7b4a6eb830e3388fa445a2a5b16e"
      
      output = []
      path = File.join(site.source, '_includes/generated/popular_repos')
      f = File.open(path, 'w')
      data = client.repositories('philchristensen', :per_page => 100)
      data.sort! { |a,b| b[:stargazers_count] <=> a[:stargazers_count] }

      data[0..13].each do |repo|
        f.write("          <li>
                  <div class=\"repo\">
                    <small class=\"language #{(repo[:language]||'').downcase}\">#{repo[:language]}</small>
                    <a class=\"name\" href=\"#{repo[:html_url]}\">#{repo[:name]}</a>
                  </div>
                </li>")
      end
      f.close()
    end
  end

end
