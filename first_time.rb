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
puts "Would you like to create a new board or use an existing one? (No lists will be deleted if you select an exisiting board.)"
puts "1: New Board"
puts "2: Existing Board"
board_option = gets.chomp.to_i

# If new board create it and set board ID and mark flag for new board.
if board_option == 1
  puts "New Board Name?"
  board_name = gets.chomp
  # create new board and set board var
  board = Board.create(name: board_name)

# If existing board display a list of all their boards and give them an integer select
else
  boards = Board.all
  boards.each_with_index do | board, i |
    puts "#{i}: #{board.name}"
  end
  # Give/get selection
  puts "Please select the board number."
  board = boards[gets.chomp.to_i]
end

# Add option to add some example card data.
puts "Would you like to add some example cards? Y/N"
if gets.chomp.upcase[0] == "Y"
  add_examples = true
end

# Using board id create the new lists.
# Set the proper Date titles for each list.
lists = {}
lists[:today] = List.create(name: @today.strftime("Today [%A]"), board_id: board.id)
lists[:tomorrow] = List.create(name: @tomorrow.strftime("Tomorrow [%A]"), board_id: board.id)
lists[:week] = List.create(name: "This Week [#{@week.begin.strftime "%b"} #{@week.begin.day.ordinalize} - #{@week.end.strftime "%b"} #{@week.end.day.ordinalize}]", board_id: board.id)
lists[:next_week] = List.create(name: "Next Week [#{@next_week.begin.strftime "%b"} #{@next_week.begin.day.ordinalize} - #{@next_week.end.strftime "%b"} #{@next_week.end.day.ordinalize}]", board_id: board.id)
lists[:month] = List.create(name: "This Month [#{@month.begin.strftime "%B"}]", board_id: board.id)
lists[:next_month] = List.create(name: "Next Month [#{@next_month.begin.strftime "%B"}]", board_id: board.id)
lists[:year] = List.create(name: "This Year [#{@year.begin.year}]", board_id: board.id)
lists[:next_year] = List.create(name: "Next Year [#{@next_year.begin.year}]", board_id: board.id)


if add_examples == true
  # ADD EXAMPLE CARDS

  # Today
  Card.create(name: "Take out the trash", list: lists[:today])
  Card.create(name: "Pickup Dry Cleaning", list: lists[:today])
  shopping_card = Card.create(name: "Go Shopping", list: lists[:today])
  # Create checklists for shopping card
  
  # Tomorrow
  
  # Week
  
  # Next Week
  Card.create(name: "Pay ", list: lists[:next_week])

  # Month
  
  # Next Month
  Card.create(name: "Pay Monthly Bills", list: lists[:month])
  # Create monthly bill checklist.
  
  # Year
  
  # Next Year
end

# Generate new config.yaml file

# Say thankyou!
