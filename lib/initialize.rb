require 'rubygems'
require 'bundler/setup'
Bundler.require :default

# Load config.yml
require 'yaml'
config = YAML.load_file 'config.yml'

# Include ActiveSupport Datetime Modules
require 'active_support/inflector'
require 'active_support/time'
require 'active_support/core_ext/integer/time'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/inflections'

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

# Date Ranges
@today      = Time.now.beginning_of_day
@tomorrow   = @today.tomorrow
@week       = (@today.beginning_of_week(:sunday) .. @today.end_of_week(:sunday))
@next_week  = (@week.begin + 1.week .. @week.end + 1.week)
@month      = (@today.beginning_of_month .. @today.end_of_month)
@next_month = (@month.begin + 1.month .. @month.end + 1.month)
@year       = (@today.beginning_of_year .. @today.end_of_year)
@next_year  = (@today.next_year.beginning_of_year .. @today.next_year.end_of_year)
