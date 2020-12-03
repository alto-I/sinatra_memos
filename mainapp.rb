# frozen_string_literal: true

require "sinatra"
require "securerandom"
require_relative "memo"

memo = Memo.new

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get "/memos" do
  @memos = memo.read_all
  @title = "main"
  erb :top
end

get "/memos/new" do
  @title = "new"
  erb :new
end

post "/memos" do
  id = SecureRandom.uuid
  memo.write(id, params[:title], params[:content])
  redirect "/memos/#{id}"
end

get "/memos/:id" do |id|
  read_memo = memo.read(id)
  @title = read_memo[0]["title"]
  @content = read_memo[0]["content"]
  @id = id
  erb :show
end

get "/memos/:id/edit" do |id|
  read_memo = memo.read(id)
  @title = read_memo[0]["title"]
  @content = read_memo[0]["content"]
  @id = id
  erb :edit
end

patch "/memos/:id" do |id|
  memo.edit(id, params[:title], params[:content])
  @id = id
  redirect "/memos/#{@id}"
end

delete "/memos/:id" do |id|
  memo.delete(id)
  redirect "/memos"
end
