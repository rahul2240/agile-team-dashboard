# Dashboards controller
class DashboardsController < ApplicationController
  def index
    @sprint = Sprint.current
    @absences = Absence.current
    @meetings = Meeting.today
    pull_requests = github_pull_requests('openSUSE/open-build-service')
    @backend_pull_requests = pull_requests.select { |pr| pr.labeled?('Backend') }
    @webui_pull_requests = pull_requests.reject { |pr| pr.labeled?('Backend') }
    @public_holidays = Holidays.between(Time.zone.today.beginning_of_week,
                                        Time.zone.today.end_of_week,
                                        %i[es gb cz])
  end

  private

  def github_pull_requests(repository)
    Rails.cache.fetch("github_pull_requests_for_#{repository}", expires_in: 30.minutes) do
      Rails.logger.info('>>> Consulting GitHub PRs......')
      pull_requests = get_from_github("https://api.github.com/repos/#{repository}/pulls")
      if pull_requests.is_a?(Array)
        pull_requests.map! do |pr|
          PullRequest.new(
            number: pr['number'],
            url: pr['html_url'],
            title: pr['title'],
            author: pr['user']['login'],
            gravatar: pr['user']['avatar_url'],
            created_at: pr['created_at'].to_date.strftime('%d-%m-%Y'),
            labels: github_labels_for_pull_request(repository, pr['number'])
          )
        end
      end
      pull_requests
    end
  end

  def github_labels_for_pull_request(repository, number)
    get_from_github("https://api.github.com/repos/#{repository}/issues/#{number}/labels")
  end

  def get_from_github(url)
    api_uri = URI(url)
    request = Net::HTTP::Get.new(api_uri)
    request.basic_auth(Rails.application.secrets.github_username, Rails.application.secrets.github_token)
    response = Net::HTTP.start(api_uri.hostname, api_uri.port, use_ssl: true) { |http| http.request(request) }
    JSON.parse(response.body)
  end
end
