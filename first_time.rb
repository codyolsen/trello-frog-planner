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
# Store it in config hash

# Double check that it is in fact a proper connection

# Ask what the new board name should be or if they should use an existing board

  # If new board create it and set board ID and mark flag for new board.
  # If existing board display a list of all their boards and give them an integer select
    # Give/get selection
    # create new board and set ID

# Using board id create the new lists.
# Retrieve their ID's in file for generating config hash.
# Set the proper Date titles for each list.

# Generate new config.yaml file

# Say thankyou!