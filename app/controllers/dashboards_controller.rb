# Dashboards controller
class DashboardsController < ApplicationController
  def index
    @sprint = Sprint.current
    @absences = Absence.today
    @meetings = Meeting.today
    pull_requests = PullRequest.from_github_repository('openSUSE/open-build-service')
    @pull_requests = {}
    @pull_requests[:backend] = pull_requests.select { |pr| pr.labeled?('Backend') }
    @pull_requests[:webui] = pull_requests.reject { |pr| pr.labeled?('Backend') }
    @pull_requests[:documentation] = PullRequest.from_github_repository('openSUSE/obs-docu')
    @pull_requests[:landing] = PullRequest.from_github_repository('openSUSE/obs-landing')
    @pull_requests[:dashboard] = PullRequest.from_github_repository('openSUSE/agile-team-dashboard')
    @public_holidays = Holidays.between(Time.zone.today.beginning_of_week,
                                        Time.zone.today.end_of_week,
                                        %i(es gb cz))
    @birthdays = User.birthdays_of_this_week
  end
end
