# frozen_string_literal: true

require 'sinatra'
require 'pg'
require 'sinatra/reloader'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def read_memos
  PG.connect(dbname: 'memo_app') do |conn|
    conn.exec('SELECT * FROM memos ORDER BY id').to_a.map { |h| h.transform_keys(&:to_sym) }
  end
end

def create_memo
  PG.connect(dbname: 'memo_app') do |conn|
    conn.exec('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])
  end
end

def find_memo
  PG.connect(dbname: 'memo_app') do |conn|
    conn.exec("SELECT * FROM memos WHERE id = #{params[:id]}").to_a.map { |h| h.transform_keys(&:to_sym) }
  end
end

def update_memo
  PG.connect(dbname: 'memo_app') do |conn|
    conn.exec("UPDATE memos SET title = $1, content = $2 where id = #{params[:id]}", [params[:title], params[:content]])
  end
end

def delete_memo
  PG.connect(dbname: 'memo_app') do |conn|
    conn.exec("DELETE FROM memos WHERE id = #{params[:id]}")
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  create_memo
  redirect '/'
end

get '/memos/:id' do
  @memo = find_memo.first
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo.first
  erb :edit
end

patch '/memos/:id' do
  update_memo
  redirect '/'
end

delete '/memos/:id' do
  delete_memo
  redirect '/'
end

not_found do
  erb :not_found
end
