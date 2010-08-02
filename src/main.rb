# Main file for running application
require "dictionary_creator"

# Running
start = Time.now
dictionary = DictionaryCreator.new :sample # :berkeley also valid
dictionary.create_grammar
dictionary.create_lexicon
dictionary.create_code_table
puts "Processed in #{Time.now - start} sec."