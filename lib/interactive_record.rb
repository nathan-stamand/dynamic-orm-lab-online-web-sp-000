require_relative "../config/environment.rb"
require 'active_support/inflector'

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
    column_names.class.
  end
  
end