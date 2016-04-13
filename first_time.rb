require 'rubygems'
require 'bundler/setup'
Bundler.require :default
require 'trello'
require 'yaml'

require_relative 'lib/dates.rb'

# TRELLO-FROG-PLANNER SETUP SCRIPT

# Check for an exisitng config.yml file and ask for overrite or cancel
if File.exist?('config.yml')
  puts "Looks like you already have an existing config.yml file."
  puts "This script will erase the existing config.yml and create a new one."
  puts "Should we continue? Y/N"
  continue = gets.chomp.upcase
  if continue[0] != "Y"
    abort
  end
end

# Ask for their Trello Secret and App Token
# Trello.open_public_key_url                         # copy your public key
# Trello.open_authorization_url key: 'yourpublickey' # copy your member token

puts "Trello API Key?"
trello_key = gets.chomp
puts "Trello App Token?"
trello_token = gets.chomp

# Double check that it is in fact a proper connection
Trello.configure do | configure |
  configure.developer_public_key = trello_key
  configure.member_token = trello_token
end

# Store it in config hash
config = {trello_key: trello_key, trello_token: trello_token}

# Ask what the new board name should be or if they should use an existing board
puts "Would you like to create a new board or use an existing one?"
puts "1: New Board"
puts "2: Existing Board"
board_option = gets.chomp.to_i

# If new board create it and set board ID and mark flag for new board.
if board_option == 1
  puts "New Board Name?"
  board_name = gets.chomp
  board = Board.create(name: board_name)

# If existing board display a list of all their boards and give them an integer select
else
  # Give/get selection
  # create new board and set ID
end

list = List.create(name: "Today", board_id: board.id)
# Using board id create the new lists.
# Retrieve their ID's in file for generating config hash.
# Set the proper Date titles for each list.

# Add option to add some sample card data.

# Generate new config.yaml file

# Say thankyou!
