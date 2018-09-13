# Check for an exisitng config.yml file and ask for overrite or cancel
unless File.exist?('config.yml')
  puts "You don't have a config file! We'll need that to list your trello ids"
  puts "Please run first_time.rb to create a new config file"
  puts "## TODO Make config file"
  abort
end

require 'rubygems'
require 'bundler/setup'
Bundler.require :default
require 'trello'
require 'yaml'
require_relative 'lib/colors.rb'
include Trello

# Load config.yml
require 'yaml'
config = YAML.load_file 'config.yml'

# Double check that it is in fact a proper connection
Trello.configure do | configure |
  configure.developer_public_key = config['trello']['app_key']
  configure.member_token = config['trello']['app_token']
end

Board.all.each do | board |
  puts "#{board.name}: #{board.id.cyan}"
  puts "LISTS:"
  board.lists.each do | list |
    puts "\t#{list.name.downcase}: #{list.id.green}"
  end
  unless board.custom_fields.empty?
    puts "CUSTOM FIELDS:"
    board.custom_fields.each do | item |
      puts "\t#{item.name.downcase}: #{item.id.green}"
    end
  end
  puts "------------".red
end
