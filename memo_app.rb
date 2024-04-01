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

get '/memos/:id/edit' do
  memos = CSV.read('./memo_app.csv')
  @memo = memos.find { |m| m[0] == params[:id] }
  erb :edit
end

patch '/memos/:id' do
  new_row = [params[:id], params[:title], params[:content]]
  memos = CSV.read('./memo_app.csv')
  new_memos = memos.map { |m| m[0] == params[:id] ? new_row : m}
  CSV.open('./memo_app.csv', 'w') do |csv|
    new_memos.each { |row| csv << row }
  end
  redirect '/'
end

delete '/memos/:id' do
  memos = CSV.read('./memo_app.csv')
  memos.delete_if { |m| m[0] == params[:id] }
  CSV.open('./memo_app.csv', 'w') do |csv|
    memos.each { |row| csv << row }
  end
  redirect '/'
end