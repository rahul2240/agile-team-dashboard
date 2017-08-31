# Dashboards controller
class DashboardsController < ApplicationController
  def index
    @sprint = Sprint.current
    @absences = Absence.current
    @meetings = Meeting.today
    pull_requests = PullRequest.from_github_repository('openSUSE/open-build-service')
    @backend_pull_requests = pull_requests.select { |pr| pr.labeled?('Backend') }
    @webui_pull_requests = pull_requests.reject { |pr| pr.labeled?('Backend') }
    @public_holidays = Holidays.between(Time.zone.today.beginning_of_week,
                                        Time.zone.today.end_of_week,
                                        %i(es gb cz))
  end
end
