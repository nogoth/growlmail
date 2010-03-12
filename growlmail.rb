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
FP.close

field = configuration["field"] || "fullcount"

value = configuration[field]

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

nvalue = (response/"fullcount").inner_html

if nvalue != value
  value = nvalue
  g.notify "growlmail Notification", "Gmail New Mail for #{configuration["username"]}", "#{value} messages #{Time.now}"
end


configuration[field] = value

finish = YAML::dump( configuration )
File.open("config.yml",'w').write(finish)
							         
