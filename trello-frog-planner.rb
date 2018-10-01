require_relative 'lib/initialize.rb'
require_relative 'lib/dates.rb'

# TODO Pull each time segment into it's own file.

def add_templates( today, source_list, target_list, card_name_template, time_index = nil)
  # Trello::CustomFieldItem.find(model.id)
  
  source_list.cards.each do |card|
    if time_index && (time_indicies = card.custom_field_items.find { |field| field.custom_field.name == "time-indicies" })
      # If the indicies are not empty, and they don't match the required index, bail out. Don't add this card.
      if !time_indicies.value["text"].empty? && !time_indicies.value["text"].split(',').include?(time_index) 
        return
      end
    end

    new_due_date = ""
    if card.due
      new_epoch = today.utc.to_i + ((card.due.to_i - today.to_i) % 86400)
      new_due_date = Time.at(new_epoch).iso8601
    end

    Trello::Card.create(
      list_id: target_list.id,
      name: card_name_template % {card_name: card.name},
      due: new_due_date,
      source_card_id: card.id,
      source_card_properties: ["attachments", "checklists", "labels", "stickers"]
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

# Hash pair set with key = date_limit, value = destination list
# Rules are evaluated top down
def process_cards_by_due_date(list, pairs)
  list.cards.each do |card|
    if card.due
      card_due_date = card.due.beginning_of_day

      # Process list rules
      pairs.each do | date_limit, list |
        if card_due_date <= date_limit
          card.move_to_list list
          break
        end
      end

    end
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
  add_templates( @today, @template_lists[:yearly], @lists[:year], "%{card_name} [#{@year.begin.year}]")

  # Update Titles
  update_titles(
    @lists[:next_year]  => "Next Year [#{@next_year.begin.year}]",
    @lists[:year]       => "This Year [#{@year.begin.year}]"
  )
end

# ON THE FIRST OF THE MONTH
if @today == @month.begin
  # Move all cards from next month to this month
  move_list_cards(@lists[:next_month], @lists[:month])

  # Check all month cards for any due dates for weeks
  process_cards_by_due_date(@lists[:year], {@month.end => @lists[:month], @next_month.end => @lists[:next_month]} )

  # Add new reoccuring monthly cards
  add_templates( @today, @template_lists[:monthly], @lists[:month], "%{card_name} [#{@month.begin.strftime "%B"}]")

  # Update Titles
  update_titles({
    @lists[:next_month] => "Next Month [#{@next_month.begin.strftime "%B"}]",
    @lists[:month] => "This Month [#{@month.begin.strftime "%B"}]"
  })
end

# ON THE FIRST OF THE WEEK
if @today == @week.begin

  # Move all cards from next week to this week
  move_list_cards( @lists[:next_week], @lists[:week] )

  # Check all month cards for any due dates for weeks
  process_cards_by_due_date( @lists[:month], {@week.end => @lists[:week], @next_week.end => @lists[:next_week]} )

  # Add new reoccuring weekly cards
  add_templates( @today, @template_lists[:weekly], @lists[:week], "%{card_name} [#{@week.begin.strftime "%b"} #{@week.begin.day.ordinalize} - #{@week.end.strftime "%b"} #{@week.end.day.ordinalize}]")

  # Update Title
  update_titles({
    @lists[:next_week]  => "Next Week [#{@next_week.begin.strftime "%b"} #{@next_week.begin.day.ordinalize} - #{@next_week.end.strftime "%b"} #{@next_week.end.day.ordinalize}]",
    @lists[:week]       => "This Week [#{@week.begin.strftime "%b"} #{@week.begin.day.ordinalize} - #{@week.end.strftime "%b"} #{@week.end.day.ordinalize}]"
  })
end

# ON EVERY NEW DAY
# Move all tomorrow cards to today
move_list_cards(@lists[:tomorrow], @lists[:today])

# Iterate through the week and see if there are any due cards to move
process_cards_by_due_date(@lists[:week], {@today => @lists[:today], @tomorrow => @lists[:tomorrow]})

# Templates
add_templates( @today, @template_lists[:daily], @lists[:today], @today.strftime("%{card_name} [%A]"), @today.strftime("%w") )

# Update Title
update_titles(
  @lists[:tomorrow] => @tomorrow.strftime("Tomorrow [%A]"),
  @lists[:today]    => @today.strftime("Today [%A]")
)


# Archive Cards from the done list.
@lists[:done].cards.each do | card |
  card.close!
end
