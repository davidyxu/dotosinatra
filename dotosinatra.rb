require 'rubygems'
require 'sinatra'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

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


def get_match(match_id)
	@key = "DF20BFFFFE13EB9A9B3A258D1EE1E15F"
	@http = Net::HTTP.new("api.steampowered.com", 443)
	@http.use_ssl = true
	@http.verify_mode = OpenSSL::SSL::VERIFY_PEER
	response = @http.request(Net::HTTP::Get.new("https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?match_id=#{match_id}&key=#{@key}"))
	data = response.body
	JSON.parse(data)["result"]
end
