require 'bundler'
Bundler.require

require_relative "zendesk_helper"

class App < Sinatra::Base
  get '/feedback' do
    erb :main
  end

  get '/acknowledge' do
    erb :acknowledge
  end

  get '/new' do
    departments = ZendeskHelper.get_departments
    erb :new, :locals => {:departments => departments}
  end

  post '/new' do
    comment = params[:target_url] + "\n\n" + params[:new_content] + "\n\n" + params[:content_additional]
    subject = "New Content"
    tag = "new_content"
    ZendeskHelper.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job_title], params[:phone_number], params[:content_added_date],params[:not_added_before], comment)
    puts params, comment, subject, tag
    redirect '/acknowledge'
  end
end