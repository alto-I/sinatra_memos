# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'

def fileread
  JSON.parse(open('memos.json').read)
end

def filedump(memos_file)
  File.open('memos.json', 'w') do |file|
    JSON.dump(memos_file, file)
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos_json = fileread
  @title = 'main'
  erb :top
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

post '/memos' do
  memos_json = fileread
  id = SecureRandom.uuid
  memos_json[id] = params
  filedump(memos_json)
  @id = id
  redirect "/memos/#{@id}"
end

get '/memos/:id' do |id|
  memos_json = fileread
  @title = memos_json[id]['title']
  @content = memos_json[id]['content']
  @id = id
  erb :show
end

get '/memos/:id/edit' do |id|
  memos_json = fileread
  @title = memos_json[id]['title']
  @content = memos_json[id]['content']
  @id = id
  erb :edit
end

patch '/memos/:id' do |id|
  memos_json = fileread
  memos_json[id]['title'] = params[:title]
  memos_json[id]['content'] = params[:content]
  filedump(memos_json)
  @id = id
  redirect "/memos/#{@id}"
end

delete '/memos/:id' do |id|
  memos_json = fileread
  memos_json.delete(id)
  filedump(memos_json)
  redirect '/memos'
end
