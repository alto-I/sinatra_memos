# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
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

get '/memos' do
  @memos_json = fileread
  @title = 'main'
  erb :top
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

post '/memos/new' do
  memos_json = fileread
  id = SecureRandom.uuid
  memos_json[id] = params
  filedump(memos_json)
  @id = id
  redirect "/memos/#{@id}"
end

get %r{/memos/([\w-]*)} do |id|
  memos_json = fileread
  @title = memos_json[id]['title']
  @content = memos_json[id]['content']
  @id = id
  erb :show
end

get '/memos/*/edit' do |id|
  memos_json = fileread
  @title = memos_json[id]['title']
  @content = memos_json[id]['content']
  @id = id
  erb :edit
end

patch '/memos/*/edit' do |id|
  memos_json = fileread
  memos_json[id]['title'] = params[:title]
  memos_json[id]['content'] = params[:content]
  filedump(memos_json)
  @id = id
  redirect "/memos/#{@id}"
  erb :edit
end

delete '/memos/*' do |id|
  memos_json = fileread
  memos_json.delete(id)
  filedump(memos_json)
  redirect '/memos'
end
