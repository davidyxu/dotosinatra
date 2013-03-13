require 'rubygems'
require 'sinatra'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

API_KEY = "AB00D7EDFE31BCDAF028E449069D28D6"

get '/' do
	erb  :form
end

post '/results' do
  @match_id = params[:match_id]
	result = get_match(@match_id)
  if result.nil?
    erb :retry_form
  else
    erb :match
  end
end

$http = Net::HTTP.new("api.steampowered.com", 443)
$http.use_ssl = true
$http.verify_mode = OpenSSL::SSL::VERIFY_PEER

def get_id_with_vanity_name(vanity_name)
  response = $http.request(Net::HTTP::Get.new("http://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key=#{API_KEY}&vanityurl=#{vanity_name}"))
  data = response.body
  JSON.parse(data)["response"]["steamid"]
end

def get_player_history(player_id)
  response = $http.request(Net::HTTP::Get.new("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=#{API_KEY}&account_id=#{player_id}"))
  data = response.body
  JSON.parse(data)["result"]
end

def get_match_details(match_id)
	response = $http.request(Net::HTTP::Get.new("https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?match_id=#{match_id}&key=#{API_KEY}"))
	data = response.body
	JSON.parse(data)["result"]
end

