require 'open-uri'
require 'nokogiri'
require 'json'
# require 'watir-webdriver'
require 'pry'
# require 'rest-client'
# require 'uri'
# require 'headless'
# "ahimmelstoss",
# "aviflombaum" ,
# "fislabstest" ,
# "irmiller22", 
# "kthffmn" ,
# "matbalez", 
# "ZalmanB", 

=begin 

- Add caching with date
- Allow for *Top 3, Top 5, Top 10

=end

@data =[]

def showProgress
		print "[ #{'%.2f' % (100*@done/@len)}% ]"	
		print "\r"
		@done+=1
end


def getHtml(username)
	html = open("https://learn.co/#{username}", "Accept"=>"text/html")
	page = Nokogiri::HTML(html)
	name = page.css('.row.user-name span.h3.title').text
	score = page.css('div[data-track-id="1564"] .col-sm-3.lessons-complete-container h3').text
	showProgress
	{:name => name, :username => username, :score => score }

end

def saveCache(sorted_data)
	b = { :date => Time.now, :data => sorted_data}
	File.write('sorted', b.to_json)
end

def fetch
	@data = []
	@users.each { |username| 
		@data << getHtml(username)
	}
	@data = sortData(@data)
	saveCache(@data)
end

def printLeaderboard(data)
	system('clear'); system('cls');
	puts "_____ LEADER BOARD ______"
	puts ""
	data = data.collect { |h|
		temp = {}
		h.each{ |k,v| temp[k.to_sym] = v }
		temp
	}
	data[0...7].each { |d| 
		puts "#{d[:name]} : #{d[:score]}  - #{d[:username]}".rjust(20)
	}
end

def sortData(d)
	sorted = d.sort_by {|x| x[:score].to_i }.reverse
	sorted	
end

def loadCache
	begin
	    data =JSON.parse(File.read('sorted'))['data']
	rescue
	    data = []
	end
	data
end

@users = ["sdolmo", "Bmesa620", "BrunaNett", "Cranium1", "DJoseph1250", "EstherMo", "GxDesign", "Ilapides", "JaimieWalker", "KingLemuel", "LewisMatos", "Omrika", "PurpIeHaze", "RaptorDog", "Samueljoli", "ZalmanB", "akpersad", "cloudleo", "damianlajara", "dylan-okeefe", "feljen", "gil93", "henrypl95", "hnae6443", "jmdelvalle", "lawrencechong", "peterhan92", "skoltz", "techsin", "wolfwzrd", "mannybeso", "Gettekt"] 
# @users = ["Bmesa620", "BrunaNett", "Cranium1"]

@len = @users.size.to_f
@done = 0

@data = loadCache

if (@data.empty? ||  ARGV[0] == '-u')
	printLeaderboard(@data)
	fetch
	printLeaderboard(@data)
else
	printLeaderboard(@data)
end










