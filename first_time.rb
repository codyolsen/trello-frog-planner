require 'rubygems'
require 'bundler/setup'
Bundler.require :default

# TRELLO-FROG-PLANNER SETUP SCRIPT
# Load config.yml
require 'yaml'

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
puts "Trello Secret?"
trello_secret = gets.chomp
puts "Trello App Token?"
trello_token = gets.chomp

# Store it in config hash

# Double check that it is in fact a proper connection

# Ask what the new board name should be or if they should use an existing board
puts "Would you like to create a new board or use an existing one?"
puts "1: New Board"
puts "2: Existing Board"
board_option = gets.chomp.to_i

# If new board create it and set board ID and mark flag for new board.
if board_option == 1
  puts "New Board Name?"
  board_name = gets.chomp
  

# If existing board display a list of all their boards and give them an integer select
else
  # Give/get selection
  # create new board and set ID
end

# Using board id create the new lists.
# Retrieve their ID's in file for generating config hash.
# Set the proper Date titles for each list.

# Generate new config.yaml file

# Say thankyou!
