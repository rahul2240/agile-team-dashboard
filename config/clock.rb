require 'clockwork'

require './config/boot'
require './config/environment'
require 'English'

module Clockwork
  # Update Burndown Chart 5-20 minutes before the Standup and 30-45 after the Review
  every(15.minutes, "update burndown chart") do |job, local_time|
    utc_offset = local_time.utc_offset # The mmeting times are stored in UTC
    time = local_time.utc + utc_offset
    Rails.logger.info "It is #{time.strftime('%F %T')}, let's check if the burndown chart needs to be updated"

    reviews = Meeting.reviews.ended_after_until(time - 45.minutes, time - 30.minutes)
    standups = Meeting.standups.started_after_until(time + 5.minutes, time + 20.minutes)

    # TODO: We need a validation to ensure that there is always one meeting here,
    # as they shouldn't overlap. Also, there should be only one active Sprint.
    if standups.any? || reviews.any?
      system "trollolo burndown --plot-to-board --output=trollolo --sprint-number=#{Sprint.current.number}"
      image_name = "trollolo/burndown-#{Sprint.current.number}.png"
      if $CHILD_STATUS.success? && File.exist?(image_name)
        Rails.logger.info 'Burndown chart updated!'

        # Upload to Github and delete local files on end of Sprint
        if reviews.any?
          commiter = '"committer": {"name": "' + ENV['GITHUB_USER'] + '", "email": "' + ENV['GITHUB_EMAIL'] + '"}, '
          authorization = "Authorization: token #{ENV['GITHUB_TOKEN']}"

          file_yaml = File.open("trollolo/burndown-data-#{Sprint.current.number}.yaml", 'rb')
          content_yaml = Base64.strict_encode64(file_yaml.read)
          options_yaml = '{"message": "New Sprint - yaml", ' + commiter + '"content": "' + content_yaml.to_s + '"}'
          correctly_updated = system "curl -i -X PUT -H '#{authorization}' -d '#{options_yaml}' #{ENV['GITHUB_API']}/burndown-data-#{Sprint.current.number}.yaml"

          file_png = File.open("trollolo/burndown-#{Sprint.current.number}.png", 'rb')
          content_png = Base64.strict_encode64(file_png.read)
          options_png = '{"message": "New Sprint - burndown chart", ' + commiter + '"content": "' + content_png.to_s + '"}'
          correctly_updated &&= system "curl -i -X PUT -H '#{authorization}' -d '#{options_png}' #{ENV['GITHUB_API']}/burndown-#{Sprint.current.number}.png"

          if correctly_updated
            Rails.logger.info 'The burndown chart was uploaded to Github 😸'

            File.delete("trollolo/burndown-data-#{Sprint.current.number}.yaml", 'rb')
            Rails.logger.info 'The local burndown chart data copy was removed'
          else
            Rails.logger.error 'There was an error and the burndown chart was NOT uploaded to Github'
          end
        end
        # TODO: implement this in Trollolo so we don't need to move the file afterwards
        system "mv #{image_name} public/burndown.png"
      else
        Rails.logger.error 'There was an error and the burndown chart was NOT updated'
      end
    else
      Rails.logger.error "The burndown chart doesn't need to be updated"
    end

    Rails.logger.info "Let's sleep other 15 minutes..."
  end
end
