require 'rubygems'
require 'bundler/setup'
Bundler.require :default

# Load config.yml
require 'yaml'
config = YAML.load_file 'config.yml'

# Set up the trello object
require 'trello'
Trello.configure do | configure |
  configure.developer_public_key = config['trello']['app_key']
  configure.member_token = config['trello']['app_token']
end

# Board
@board = Trello::Board.find config['trello']['board']

# Lists
@lists = {}
config['trello']['lists'].each do | list |
  unless list[1].nil?
    @lists[list[0].to_sym] = Trello::List.find list[1]
  end
end

# Template Lists
@template_lists = {}
config['trello']['template_lists'].each do | list |
  unless list[1].nil?
    @template_lists[list[0].to_sym] = Trello::List.find list[1]
  end
end