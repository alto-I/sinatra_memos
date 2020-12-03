# frozen_string_literal: true

require "pg"

class Memo
  def initialize
    @memos_db = PG.connect(dbname: "memos")
  end

  def read_all
    @memos_db.exec("SELECT * FROM memos;")
  end

  def read(id)
    @memos_db.exec("SELECT * FROM memos WHERE id = $1;", [id])
  end

  def write(id, title, content)
    if title == ""
      @memos_db.exec("INSERT INTO memos VALUES ($1, DEFAULT, $2);", [id, content])
    else
      @memos_db.exec("INSERT INTO memos VALUES ($1, $2, $3);", [id, title, content])
    end
  end

  def edit(id, title, content)
    if title == ""
      @memos_db.exec("UPDATE memos SET title = DEFAULT, content = $1 WHERE id= $2;", [content, id])
    else
      @memos_db.exec("UPDATE memos SET title = $1 ,content = $2 WHERE id = $3;", [title, content, id])
    end
  end

  def delete(id)
    @memos_db.exec("DELETE FROM memos WHERE id = $1;", [id])
  end
end
