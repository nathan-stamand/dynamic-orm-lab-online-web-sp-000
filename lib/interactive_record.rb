require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord
  
  def self.table_name 
    self.to_s.downcase.pluralize
  end
  
  def self.column_names
    DB[:conn].results_as_hash = true
    
    sql = <<-SQL 
    PRAGMA table_info(#{table_name})
    SQL
    
    table_info = DB[:conn].execute(sql)
    column_names = []
    
    table_info.each do |column|
      column_names << column["name"]
    end 
    column_names
  end
  
  def initialize(info = {})
    info.each do |property, value|
      self.send("#{property}=", value)
    end
  end
  
  def table_name_for_insert 
    self.class.to_s.downcase.pluralize
  end
  
  def col_names_for_insert 
    DB[:conn].results_as_hash = true
    
    sql = <<-SQL 
    PRAGMA table_info(#{table_name_for_insert})
    SQL
    
    table_info = DB[:conn].execute(sql)
    column_names = []
    
    table_info.each do |column|
      column_names << column["name"]
    end 
    column_names.join(", ").gsub('id, ', '')
  end
  
  def values_for_insert 
    values = [] 
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end 
    values.join(', ')
  end
  
  def save 
    sql = <<-SQL 
    INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})
    SQL
    
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end 
  
  def self.find_by_name(name)
    sql = <<-SQL 
    SELECT * FROM #{table_name} WHERE name = ?
    SQL
    
    DB[:conn].execute(sql, name)
  end 
  
  def self.find_by(info = {})
    DB[:conn].results_as_hash = true
    
    sql = <<-SQL 
    SELECT * FROM #{table_name} WHERE #{info.keys[0]} = '#{info.values[0].to_s}' 
    SQL
    
    
    DB[:conn].execute(sql)
    
    
  end 
  
end