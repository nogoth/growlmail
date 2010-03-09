require 'yaml'
require 'hpricot'
require 'ruby-growl'
require 'open-uri'

g = Growl.new "localhost", "growlmail",
              ["growlmail Notification"]


FP = File.open("config.yml")
configuration = YAML::load( FP )

#we expect at least a url, check for a username
if configuration["username"]
				if ! configuration["password"]
								exit -1
				end
		    url = "#{configuration["username"]}:#{configuration["password"]}@#{configuration["url"]}" 
else
				url = configuration["url"]
end
Hpricot(open "https://" + url)

							g.notify "growlmail Notification", "newmail", "msg count"
							         
