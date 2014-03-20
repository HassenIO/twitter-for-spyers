require 'sinatra'
require 'sequel'

before do
	puts "\n[DateTime] #{DateTime.now}"
	puts "[Params] #{params}"
end

# Schema:
DB = Sequel.connect( 'sqlite://twitter-for-spyers.db' )

# DB.create_table :tweets do
# 	primary_key :id
# 	String :name, required: true
# 	Text :message, required: true
# 	DateTime :created_at
# 	DateTime :updated_at
# end

# Models:
class Tweet < Sequel::Model(:tweets)
	def before_create
		self.created_at ||= DateTime.now
		self.updated_at ||= DateTime.now
	    super
	end
end

# Routes:
get '/' do
	puts "[Route] GET /"
	@tweets = Tweet.order(:id).all
	puts "[Tweets] #{@tweets}"
	erb :index
end

post '/' do
	puts "[Route] POST /"

	tweet = Tweet.new
	tweet.name = params[:name]
	tweet.message = params[:message]
	t = tweet.save

	puts "[new tweet] #{t}"
	
	redirect '/'
end