# Dashboards controller
class DashboardsController < ApplicationController
  def index
    @sprint = Sprint.current
    @absences = Absence.current
    @meetings = Meeting.today
    @this_week = Meeting.today
    @pull_requests = github_pull_requests('openSUSE/open-build-service')
    @public_holidays = Holidays.between(Time.zone.today.beginning_of_week,
                                        Time.zone.today.end_of_week,
                                        %i[es gb cz])
  end

  private

  def github_pull_requests(repository)
    body = JSON.parse(open("https://api.github.com/repos/#{repository}/pulls").read)
    pull_requests = []
    if body.is_a? Array
      pull_requests = []
      body.each do |pr|
        pull_requests << PullRequest.new(
          number: pr['number'],
          url: pr['html_url'],
          title: pr['title'],
          author: pr['user']['login'],
          gravatar: pr['user']['avatar_url'],
          created_at: pr['created_at'].to_date.strftime('%d-%m-%Y')
        )
      end
    end
    pull_requests
  end
end
