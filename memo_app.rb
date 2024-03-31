require 'sinatra'
require 'csv'

get '/' do
  erb :index
end

get '/new' do
  erb :new
end

post '/memos' do
  CSV.open('./memo_app.csv','a') do |csv|
    csv << [params[:title], params[:content]]
  end
  redirect '/'
end