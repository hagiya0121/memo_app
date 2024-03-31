require 'sinatra'
require 'debug'
require 'csv'
require 'securerandom'

get '/' do
  @memos =  CSV.read('./memo_app.csv')
  erb :index
end

get '/new' do
  erb :new
end

post '/memos' do
  CSV.open('./memo_app.csv', 'a') do |csv|
    id = SecureRandom.hex(4)
    csv << [id, params[:title], params[:content]]
  end
  redirect '/'
end

get '/memos/:id' do
  memos = CSV.read('./memo_app.csv')
  @memo = memos.find { |m| m[0] == params[:id] }
  erb :show
end