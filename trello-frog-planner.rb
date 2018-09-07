require_relative 'lib/initialize.rb'
require_relative 'lib/dates.rb'

# TODO Pull each time segment into it's own file.

def add_templates(source_list, target_list, card_name_template)
  # Trello::CustomFieldItem.find(model.id)
  source_list.cards.each do |card|
    Trello::Card.create(
      list_id: target_list.id,
      name: card_name_template % {card_name: card.name},
      source_card_id: card.id,
      source_card_properties: :all
    )
  end
end

# Hash of lists and their new titles {List => String, ...}
def update_titles(lists)
  lists.each do |list, title|
    list.name = title
    list.save
  end
end

def move_list_cards(source_list, target_list)
  source_list.cards.each do | card |
    card.move_to_list target_list
  end
end

# ON THE FIRST OF THE YEAR
if @today == @year.begin
  # Move all next year to this year on Jan 1st
  move_list_cards(@lists[:next_year], @lists[:year])

  # Add new reoccuring yearly cards
  add_templates(@template_lists[:yearly], @lists[:year], "%{card_name} [#{@year.begin.year}]")

  # Update Titles
  update_titles(
    @lists[:next_year]: "Next Year [#{@next_year.begin.year}]",
    @lists[:year]: "This Year [#{@year.begin.year}]",
  )
end

# ON THE FIRST OF THE MONTH
if @today == @month.begin
  # Move all cards from next month to this month
  move_list_cards(@lists[:next_month], @lists[:month])

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
  @template_lists[:monthly].cards.each do |card|
    # Trello::CustomFieldItem.find(model.id)

    Trello::Card.create(
      list_id: @lists[:month].id,
      name: @today.strftime("#{card.name} [#{@month.begin.strftime "%B"}]"),
      source_card_id: card.id,
      source_card_properties: :all
    )
  end

  # Update Title
  @lists[:next_month].name = "Next Month [#{@next_month.begin.strftime "%B"}]"
  @lists[:next_month].save
  @lists[:month].name = "This Month [#{@month.begin.strftime "%B"}]"
  @lists[:month].save
end

# ON THE FIRST OF THE WEEK
if @today == @week.begin

  # Move all cards from next week to this week
  move_list_cards(@lists[:next_week], @lists[:week])

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
  add_templates(@template_lists[:weekly], @lists[:week], "%{card_name} [#{@week.begin.strftime "%b"} #{@week.begin.day.ordinalize} - #{@week.end.strftime "%b"} #{@week.end.day.ordinalize}]")

  # Update Title
  @lists[:next_week].name = "Next Week [#{@next_week.begin.strftime "%b"} #{@next_week.begin.day.ordinalize} - #{@next_week.end.strftime "%b"} #{@next_week.end.day.ordinalize}]"
  @lists[:next_week].save
  @lists[:week].name = "This Week [#{@week.begin.strftime "%b"} #{@week.begin.day.ordinalize} - #{@week.end.strftime "%b"} #{@week.end.day.ordinalize}]"
  @lists[:week].save
end

# ON EVERY NEW DAY

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

add_templates(@template_lists[:daily], @lists[:today], @today.strftime("%{card_name} [%A]"))

# Update Title
@lists[:tomorrow].name = @tomorrow.strftime("Tomorrow [%A]")
@lists[:tomorrow].save
@lists[:today].name = @today.strftime("Today [%A]")
@lists[:today].save

# Archive Cards from the done list.
@lists[:done].cards.each do | card |
  card.close!
end
