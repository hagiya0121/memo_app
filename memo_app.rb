# frozen_string_literal: true

require 'sinatra'
require 'csv'
require 'securerandom'
require 'sinatra/reloader'

CSV_HEADERS = %w[id title content].freeze

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load_memos
  CSV.read('./memo_app.csv', headers: true, header_converters: :symbol).map(&:to_h)
end

def find_memo
  load_memos.find { |m| m[:id] == params[:id] }
end

def write_memos(memos)
  CSV.open('./memo_app.csv', 'w') do |csv|
    csv << CSV_HEADERS
    memos.each { |memo| csv << memo }
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  CSV.open('./memo_app.csv', 'a') do |csv|
    uuid = SecureRandom.uuid
    csv << [uuid, params[:title], params[:content]]
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
  new_memos = load_memos.map { |m| m[:id] == params[:id] ? new_row : m.values }
  write_memos(new_memos)
  redirect '/'
end

delete '/memos/:id' do
  memos = load_memos.reject { |m| m[:id] == params[:id] }.map(&:values)
  write_memos(memos)
  redirect '/'
end

not_found do
  erb :not_found
end
