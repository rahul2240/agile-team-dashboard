require 'clockwork'

require './config/boot'
require './config/environment'
require 'English'

module Clockwork
  every(15.minutes, "update burndown chart") do |job, local_time|
    # Update Burndown Chart 5-20 minutes before the Standup
    utc_offset = local_time.utc_offset # The mmeting times are stored in UTC
    time = local_time.utc + utc_offset
    puts "It is #{time.strftime('%F %T')}, let's check if the standup starts soon."

    standups = Meeting.standups.started_after_until(time + 5.minutes, time + 20.minutes)

    if standups.any?
      puts 'The standup starts soon'
      system 'trollolo burndown --plot-to-board --output=trollolo'
      if $CHILD_STATUS.success?
        puts 'Burndown chart updated!'
      else
        puts 'There was an error and the burndown chart was NOT updated'
      end
    else
      puts 'No standups found'
    end
    
    # TODO: Upload the burndown chart to Github

    puts "Let's sleep other 15 minutes..."
  end
end