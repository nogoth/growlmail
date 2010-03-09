require 'yaml'
require 'hpricot'
require 'ruby-growl'
require 'patron'

g = Growl.new "localhost", "growlmail",
              ["growlmail Notification"]

hess = Patron::Session.new
hess.insecure = true #because we don't care to validate right now

FP = File.open("config.yml")
configuration = YAML::load( FP )

field = configuration["field"] || "fullcount"

#we expect at least a url, check for a username
if configuration["username"]
				if ! configuration["password"]
								exit -1
				end
		    url = "#{configuration["username"]}:#{configuration["password"]}@#{configuration["url"]}" 
else
				url = configuration["url"]
end

response = Hpricot( hess.get("https://" + url).body )

new_mail = (response/"fullcount").inner_html

g.notify "growlmail Notification", "Gmail New Mail for #{configuration["username"]}", "#{new_mail} messages #{Time.now}"
							         
