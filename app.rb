require 'sinatra'
require 'json'
require 'aws-sdk-dynamodb'

dynamo_client = Aws::DynamoDB::Client.new(region: 'us-east-1')

get '/' do
	'A microservice for counting bicyclists!'
end

get '/latest' do
	data_output = dynamo_client.scan(table_name:'bicyclist').items
	sorted_data = data_output.sort_by { |arr| arr["date"] } 
	sorted_data.last.to_json
end

get '/health' do
	'OK'
end
