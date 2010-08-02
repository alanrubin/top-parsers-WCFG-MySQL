require "rubygems"
require "mysql"

class DatabaseInitializer
  
  TABLE = {
    :Nonterminals => "(name varchar(15) primary key, value int unique)",
    :BinaryGrammar => "(head int, body1 int, body2 int, weight int) PARTITION BY HASH(body1 + 13 * body2) PARTITIONS 10",
    :UnaryGrammar => "(head int, body int, weight int)",
    :Lexicon => "(nonterminal int, terminal varbinary(100), weight int)",
    :queue1 => "(id int primary key auto_increment, s int, e int, name int, lchild int, rchild int, weight int, popped int default 0, terminal varbinary(100))",
    :queue2 => "(id int primary key auto_increment, s int, e int, name int, lchild int, rchild int, weight int, popped int default 0, terminal varbinary(100))"
  }
  
  def initialize(*args)
    @my = Mysql.new(args[0],args[1],args[2],args[3])
    @my.autocommit(true)
  end
  
  def drop_tables
    TABLE.each_key do |table|
      @my.query("DROP TABLE IF EXISTS #{table} CASCADE")
    end
  end
  
  def create_tables
    TABLE.each do |table, description|
      @my.query("CREATE TABLE #{table}#{description}")
    end
  end
  
  
end