# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './memo'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = Memo.read_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @memo = Memo.new(title: params[:title], content: params[:content])
  @memo.create_memo
  redirect '/'
end

get '/memos/:id' do
  @memo = Memo.find_memo(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = Memo.find_memo(params[:id])
  erb :edit
end

patch '/memos/:id' do
  @memo = Memo.new(id: params[:id], title: params[:title], content: params[:content])
  @memo.update_memo
  redirect '/'
end

delete '/memos/:id' do
  memo = Memo.find_memo(params[:id])
  memo.delete_memo
  redirect '/'
end

not_found do
  erb :not_found
end
