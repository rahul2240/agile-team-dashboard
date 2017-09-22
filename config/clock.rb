require 'clockwork'

require './config/boot'
require './config/environment'
require 'English'

module Clockwork
  # Update Burndown Chart 5-20 minutes before the Standup and 30-45 after the Review
  every(15.minutes, "update burndown chart") do |job, local_time|
    utc_offset = local_time.utc_offset # The mmeting times are stored in UTC
    time = local_time.utc + utc_offset
    puts "It is #{time.strftime('%F %T')}, let's check if the burndown chart needs to be updated"

    reviews = Meeting.reviews.ended_after_until(time - 45.minutes, time - 30.minutes)
    standups = Meeting.standups.started_after_until(time + 5.minutes, time + 20.minutes)

    if standups.any? || reviews.any?
      system 'trollolo burndown --plot-to-board --output=trollolo'
      if $CHILD_STATUS.success?
        puts 'Burndown chart updated!'
      else
        puts 'There was an error and the burndown chart was NOT updated'
      end
    else
      puts "The burndown chart doesn't need to be updated"
    end

    # TODO: Upload the burndown chart to Github

    puts "Let's sleep other 15 minutes..."
  end
end