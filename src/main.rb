# Main file for running application
require "dictionary_creator"
require "database_initializer"

# Running
start = Time.now
# dictionary = DictionaryCreator.new :sample # :berkeley also valid
# dictionary.create_grammar
# dictionary.create_lexicon
# dictionary.create_code_table
database = DatabaseInitializer.new('127.0.0.1','root','abc123','top_parsers')
database.drop_tables
database.create_tables
database.load_data_infile
database.create_indexes
database.create_order_by
puts "Processed in #{Time.now - start} sec."