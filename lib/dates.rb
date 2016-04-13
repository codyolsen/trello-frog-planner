# Include ActiveSupport Datetime Modules
require 'active_support/inflector'
require 'active_support/time'
require 'active_support/core_ext/integer/time'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/inflections'

# Date Ranges
@today      = Time.now.beginning_of_day
@tomorrow   = @today.tomorrow
@week       = (@today.beginning_of_week(:sunday) .. @today.end_of_week(:sunday))
@next_week  = (@week.begin + 1.week .. @week.end + 1.week)
@month      = (@today.beginning_of_month .. @today.end_of_month)
@next_month = (@month.begin + 1.month .. @month.end + 1.month)
@year       = (@today.beginning_of_year .. @today.end_of_year)
@next_year  = (@today.next_year.beginning_of_year .. @today.next_year.end_of_year)