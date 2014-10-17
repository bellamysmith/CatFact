class UsersController < ApplicationController
require 'twilio-ruby'
require 'unirest'


  def index
  end

  def create
@response = Unirest.get "http://catfacts-api.appspot.com/api/facts"

	#puts response.body, response.code, response.message, response.headers.inspect


  	@user = User.new(phone: params[:user][:phone]);
  	if @user.save
 		account_sid = ENV['TWILIO_KEY']
		auth_token = ENV['TWILIO_AUTH'] 
 
# set up a client to talk to the Twilio REST API 
		@client = Twilio::REST::Client.new account_sid, auth_token 
 
		@client.account.messages.create({
			:from => ENV['TWILIO_PHONE'], 
			:to => @user.phone, 
			:body => params[:user][:text] + " " + @response.body["facts"][0],  
		})
		redirect_to root_path
	end
  end

  def new
  end
end

