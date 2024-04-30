# frozen_string_literal: true

require 'pg'
require 'connection_pool'

class Memo
  attr_accessor :id, :title, :content

  def self.connection_pool
    @connection_pool ||= ConnectionPool.new(size: 5, timeout: 5) do
      PG.connect(dbname: 'memo_app')
    end
  end

  connection_pool.with do |conn|
    conn.prepare('find', 'SELECT * FROM memos WHERE id = $1')
    conn.prepare('create', 'INSERT INTO memos (title, content) VALUES ($1, $2)')
    conn.prepare('update', 'UPDATE memos SET title = $2, content = $3 WHERE id = $1')
    conn.prepare('delete', 'DELETE FROM memos WHERE id = $1')
  end

  def initialize(title:, content:, id: nil)
    @id = id
    @title = title
    @content = content
  end

  def self.find_memo(id)
    connection_pool.with do |conn|
      memo = conn.exec_prepared('find', [id]).first
      new(id: memo['id'], title: memo['title'], content: memo['content'])
    end
  end

  def self.read_memos
    connection_pool.with do |conn|
      conn.exec('SELECT * FROM memos ORDER BY id').map do |memo|
        new(id: memo['id'], title: memo['title'], content: memo['content'])
      end
    end
  end

  def create_memo
    Memo.connection_pool.with do |conn|
      conn.exec_prepared('create', [@title, @content])
    end
  end

  def update_memo
    Memo.connection_pool.with do |conn|
      conn.exec_prepared('update', [@id, @title, @content])
    end
  end

  def delete_memo
    Memo.connection_pool.with do |conn|
      conn.exec_prepared('delete', [@id])
    end
  end
end
