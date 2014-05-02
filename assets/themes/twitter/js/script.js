/*
 * philchristensen github home
 * by Phil Christensen <phil@bubblehouse.org>
 * 
 */
(function($){
	function formatLatestRepo(repo){
		var label = $('<div>').attr('class', 'repo');
		var language = repo.language || '';
		label.append($('<small class="language">').addClass(language.toLowerCase()).html(language || 'n/a'));
		label.append($('<a>').addClass("name").attr('href', repo.html_url).html(repo.name));
		
		return label;
	}
	
	function formatRepo(repo){
		var label = $('<div>').attr('class', 'repo');
		var language = repo.language || '';
		label.append($('<a>').html(repo.name));
		label.append($('<small class="language">').addClass(language.toLowerCase()).html(language || 'n/a'));

		var extras = $('<div>').addClass("extras");
		label.append(extras);
		
		label.append($('<p>').html(repo.description));
		
		var time = $("<a>").attr("href", repo.html_url + "/commits").text(strftime("%h %e, %Y", repo.pushed_at));
		extras.append($("<span>").addClass("time").append(time));

		if(repo.watchers > 1){
			extras.append('<span class="bullet">&sdot;</span>');
			var watchers = $("<a>").attr("href", repo.html_url + "/watchers").text(repo.watchers + " watchers");
			extras.append($("<span>").addClass("watchers").append(watchers));
		}
		
		if(repo.forks > 1){
			extras.append('<span class="bullet">&sdot;</span>');
			var forks = $("<a>").attr("href", repo.html_url + "/network").text(repo.forks + " forks");
			extras.append($("<span>").addClass("forks").append(forks));
		}
		
		return label;
	}
	
	function formatGist(gist){
		var label = $('<div>').attr('class', 'gist');
		for(var i in gist.files){
			var language = gist.files[i].language || '';
			label.append($('<small class="language>').addClass(language.toLowerCase()).html(language || 'n/a'));
			break;
		}
		label.append($('<a>').attr('href', gist.html_url).html(gist.description || '(none)'));
		return label;
	}
	
	$(document).ready(function(){
		var g = $('body').github({
			url: 'https://api.github.com/',
			user: 'philchristensen',
		});
		g.github('repos', function(data){
			$('.public-repo-num').html(data.repos.length);
			var latest = data.threeFreshest();
			for(index in latest){
				var label = formatLatestRepo(latest[index]);
				$('.recently-updated-repos').append($('<li>').html(label));
			}
			var hottest = data.byHotness();
			for(index in hottest){
				var label = formatRepo(hottest[index]);
				$('.all-repos').append($('<li>').html(label));
			}
		});
		g.github('gists', function(data){
			for(var i in data.data){
				var label = formatGist(data.data[i]);
				$('.recent-gist-list').append($('<li>').html(label));
			}
		});
	});
})(jQuery);