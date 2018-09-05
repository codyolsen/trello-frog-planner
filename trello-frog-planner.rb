require_relative 'lib/initialize.rb'

# TODO Pull each time segment into it's own file.

# ON THE FIRST OF THE YEAR
if @today == @year.begin
  # Move all next year to this year on Jan 1st
  @lists[:next_year].cards.each do | card |
      card.move_to_list @lists[:year]
  end

  # Add new reoccuring yearly cards
  # 

  # Update Title
  @lists[:next_year].name = "Next Year [#{@next_year.begin.year}]"
  @lists[:next_year].save
  @lists[:year].name = "This Year [#{@year.begin.year}]"
  @lists[:year].save
end

# ON THE FIRST OF THE MONTH
if @today == @month.begin
  # Move all cards from next month to this month
  @lists[:next_month].cards.each do | card |
    card.move_to_list @lists[:month]
  end

  # Check all month cards for any due dates for weeks
  @lists[:year].cards.each do | card |
    # Set Due date
    if card.due
      due_date = card.due.beginning_of_day

      # Move due to today
      if due_date <= @next_month.end 
        card.move_to_list @lists[:next_month]

      # Move due cards to tomorrow
      elsif due_date <= @month.end 
        card.move_to_list @lists[:month]
      end
    end
  end


  # Add new reoccuring monthly cards
  # 

  # Update Title
  @lists[:next_month].name = "Next Month [#{@next_month.begin.strftime "%B"}]"
  @lists[:next_month].save
  @lists[:month].name = "This Month [#{@month.begin.strftime "%B"}]"
  @lists[:month].save
end

# ON THE FIRST OF THE WEEK
if @today == @week.begin

  # Move all cards from next week to this week
  @lists[:next_week].cards.each do | card |
    card.move_to_list @lists[:week]
  end

  # Check all month cards for any due dates for weeks
  @lists[:month].cards.each do | card |
    # Set Due date
    if card.due
      due_date = card.due.beginning_of_day

      # Move due cards to this week
      if due_date <= @week.end
        card.move_to_list @lists[:week]
      
      # Move due to next week
      elsif due_date <= @next_week.end 
        card.move_to_list @lists[:next_week]
      end
    end
  end


  # Add new reoccuring weekly cards
  # 

  # Update Title
  @lists[:next_week].name = "Next Week [#{@next_week.begin.strftime "%b"} #{@next_week.begin.day.ordinalize} - #{@next_week.end.strftime "%b"} #{@next_week.end.day.ordinalize}]"
  @lists[:next_week].save
  @lists[:week].name = "This Week [#{@week.begin.strftime "%b"} #{@week.begin.day.ordinalize} - #{@week.end.strftime "%b"} #{@week.end.day.ordinalize}]"
  @lists[:week].save
end

# ON EVERY NEW DAY
if true

  # Move all tomorrow cards to today
  @lists[:tomorrow].cards.each do | card |
    card.move_to_list @lists[:today]
  end

  # Iterate through the week and see if there are any due cards to move
  @lists[:week].cards.each do | card |
    # Set Due date
    if card.due
      due_date = card.due.beginning_of_day

      # Move due to today
      if due_date <= @today 
        card.move_to_list @lists[:today]
        
      # Move due cards to tomorrow
      elsif due_date <= @tomorrow
        card.move_to_list @lists[:tomorrow]
      end
    end
  end


  # Add new reoccuring daily cards
  # 

  # Update Title
  @lists[:tomorrow].name = @tomorrow.strftime("Tomorrow [%A]")
  @lists[:tomorrow].save
  @lists[:today].name = @today.strftime("Today [%A]")
  @lists[:today].save

  # Archive Cards from the done list.
  @lists[:done].cards.each do | card |
    card.close!
  end
end
