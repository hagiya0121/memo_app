# frozen_string_literal: true

require 'sinatra'
require 'pg'
require 'connection_pool'
require 'sinatra/reloader'

POOL = ConnectionPool.new(size: 5, timeout: 5) do
  PG.connect(dbname: 'memo_app')
end

POOL.with do |conn|
  conn.prepare('find', 'SELECT * FROM memos WHERE id = $1')
  conn.prepare('create', 'INSERT INTO memos (title, content) VALUES ($1, $2)')
  conn.prepare('update', 'UPDATE memos SET title = $1, content = $2 WHERE id = $3')
  conn.prepare('delete', 'DELETE FROM memos WHERE id = $1')
end

def find_memo
  POOL.with do |conn|
    conn.exec_prepared('find', [params[:id]]).to_a.map { |h| h.transform_keys(&:to_sym) }
  end
end

def read_memos
  POOL.with do |conn|
    conn.exec('SELECT * FROM memos ORDER BY id').to_a.map { |h| h.transform_keys(&:to_sym) }
  end
end

def create_memo
  POOL.with do |conn|
    conn.exec_prepared('create', [params[:title], params[:content]])
  end
end

def update_memo
  POOL.with do |conn|
    conn.exec_prepared('update', [params[:title], params[:content], params[:id]])
  end
end

def delete_memo
  POOL.with do |conn|
    conn.exec_prepared('delete', [params[:id]])
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
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
