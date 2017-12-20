#!/usr/bin/env ruby

# Bare minimum code to read some channel history from slack via their api

require 'rest-client'
require 'json'
require 'optparse'

o = 0
l = "now"
hasmore = true
ts = 0


if ARGV.count != 1
	puts "usage: slackr <token-api-key>"
	exit
end

ak = ARGV[0]


chns = RestClient.get 'https://slack.com/api/channels.list' , { :params => { 'token' => ak  } }
chns = JSON.parse(chns) 
puts
puts "List of channels"
puts "----------------"
puts 

chns['channels'].each do |chan|
	puts chan['name'] + ' ID: ' +  chan['id']
end

usrs = RestClient.get 'https://slack.com/api/users.list' , { :params => { 'token' => ak  } }
usrts = JSON.parse(usrs) 
puts
puts "List of users"
puts "-------------"
puts

usrts['members'].each do |usr|
	puts usr['name'] + ' ID: ' +  usr['id']
end


chns['channels'].each do |curchan|

puts
puts	" -- Channel Dump for " + curchan['name'] + " begins here -- "
puts


hasmore=true

while hasmore

	msgs = JSON.parse( RestClient.get 'https://slack.com/api/channels.history' , { :params =>  { 'token' => ak , 'channel' => curchan['id'], 'count' => '10' ,  'latest' => ts.to_s } } )

	msgs['messages'].each do |contents|

		o = o+1
		puts  contents['user'] + ': ' +  contents['text'].to_s
		ts = contents['ts']
	end

	hasmore = msgs['has_more']

end

puts o.to_s + ' messages processed.'

end
