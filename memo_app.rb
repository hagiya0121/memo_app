require 'sinatra'
require 'csv'
require 'securerandom'
require 'sinatra/reloader'

before do
  skip_paths = ['/memos/new', '/memos']
  @memos = CSV.read('./memo_app.csv') unless skip_paths.include?(request.path_info)
end

def find_memo
  @memos.find { |m| m[0] == params[:id] }
end

def write_memos(memos)
  CSV.open('./memo_app.csv', 'w') do |csv|
    memos.each { |row| csv << row }
  end
end

get '/' do
  erb :index
end

get '/memos/new' do
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
  @memo = find_memo
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo
  erb :edit
end

patch '/memos/:id' do
  new_row = [params[:id], params[:title], params[:content]]
  new_memos = @memos.map { |m| m[0] == params[:id] ? new_row : m}
  write_memos(new_memos)
  redirect '/'
end

delete '/memos/:id' do
  @memos.delete_if { |m| m[0] == params[:id] }
  write_memos(@memos)
  redirect '/'
end

not_found do
  erb :not_found
end