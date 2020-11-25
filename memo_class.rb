# frozen_string_literal: true

require 'pg'

class Memo
  def initialize
    @memos_db = PG.connect(dbname: 'memos')
  end

  def read_all
    @memos_db.exec('SELECT * FROM memos')
  end

  def read(id)
    memo = @memos_db.exec("SELECT * FROM memos WHERE id = '#{id}'")
    title = memo[0]['title']
    content = memo[0]['content']
    [title, content]
  end

  def write(id, title, content)
    title = '無題' if title == ''
    @memos_db.exec("INSERT INTO memos VALUES ('#{id}', '#{title}', '#{content}')")
  end

  def edit(id, title, content)
    title = '無題' if title == ''
    @memos_db.exec("UPDATE memos SET title = '#{title}' ,content = '#{content}' WHERE id = '#{id}'")
  end

  def delete(id)
    @memos_db.exec("DELETE FROM memos WHERE id = '#{id}'")
  end
end
