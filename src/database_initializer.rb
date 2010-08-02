require "rubygems"
require "mysql"

class DatabaseInitializer
  
  TABLE = {
    :Nonterminals => 
      { 
        :desc => "(name varchar(15) primary key, value int unique)",
        :indexes => [],
        :file => "/../tmp/code_table.txt"
      },
    :BinaryGrammar => 
      {
        :desc => "(head int, body1 int, body2 int, weight int) PARTITION BY HASH(body1 + 13 * body2) PARTITIONS 10",
        :indexes => ["INDEX binary_bodies_index(body1,body2)"],
        :order_by => "body1,body2",
        :file => "/../tmp/binary.txt"
      },
    :UnaryGrammar => 
      {  
        :desc => "(head int, body int, weight int)",
        :indexes => ["INDEX unary_body_index(body)"],
        :file => "/../tmp/unary.txt"
      },
    :Lexicon => 
      {
        :desc => "(nonterminal int, terminal varbinary(100), weight int)",
        :indexes => ["INDEX lexicon_index(terminal)"],
        :file => "/../tmp/lexicon.txt"
      },
    :queue1 => 
      {
        :desc => "(id int primary key auto_increment, s int, e int, name int, lchild int, rchild int, weight int, popped int default 0, terminal varbinary(100))",
        :indexes => ["INDEX popped_index(popped)", "INDEX s_index(s)", "INDEX e_index(e)"]
      },
    :queue2 => 
      {
        :desc => "(id int primary key auto_increment, s int, e int, name int, lchild int, rchild int, weight int, popped int default 0, terminal varbinary(100))",
        :indexes => ["INDEX popped_index(popped)", "INDEX s_index(s)", "INDEX e_index(e)"]
      }
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
      @my.query("CREATE TABLE #{table}#{description[:desc]}")
    end
  end
  
  def create_indexes
    TABLE.each do |table, description|
      description[:indexes].each do |index|
        @my.query("ALTER TABLE #{table} ADD #{index}")
      end
    end
  end
  
  def create_order_by
    TABLE.each do |table, description|
      @my.query("ALTER TABLE #{table} ORDER BY #{description[:order_by]}") unless description[:order_by].nil?
    end
  end
  
  def load_data_infile
    TABLE.each do |table, description|
      unless description[:file].nil?
        file_path = File.expand_path(File.dirname(__FILE__) + description[:file])  
        @my.query("LOAD DATA LOCAL INFILE '#{file_path}' INTO TABLE #{table} FIELDS TERMINATED BY '+' LINES TERMINATED BY '\n'")
      end
    end
  end
  
  
end