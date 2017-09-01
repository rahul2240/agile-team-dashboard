require 'net/http'

class PullRequest
  include ActiveModel::Model
  attr_accessor :number, :url, :title, :author, :gravatar, :created_at, :labels

  def labeled?(tag)
    labels.map { |label| label['name'] }.include?(tag)
  end

  def font_color_for(label)
    r = label['color'][0..1].to_i(16)
    g = label['color'][2..3].to_i(16)
    b = label['color'][4..5].to_i(16)
    r + g + b > 382 ? 'black' : 'white'
  end

  def self.from_github_repository(repository)
    Rails.cache.fetch("github_pull_requests_for_#{repository}", expires_in: 10.minutes) do
      Rails.logger.info(">>> Consulting GitHub PRs for #{repository}......")
      pull_requests = github_api_get("https://api.github.com/repos/#{repository}/pulls")
      return [] unless pull_requests.is_a?(Array)
      pull_requests.map { |pull_request| new_from_github(repository, pull_request) }
    end
  end

  def self.new_from_github(repository, pull_request)
    new(
      number: pull_request['number'],
      url: pull_request['html_url'],
      title: pull_request['title'],
      author: pull_request['user']['login'],
      gravatar: pull_request['user']['avatar_url'],
      created_at: pull_request['created_at'].to_date.strftime('%d-%m-%Y'),
      labels: github_labels_for_pull_request(repository, pull_request['number'])
    )
  end
  private_class_method :new_from_github

  def self.github_api_get(url)
    api_uri = URI(url)
    request = Net::HTTP::Get.new(api_uri)
    request.basic_auth(Rails.application.secrets.github_username, Rails.application.secrets.github_token)
    response = Net::HTTP.start(api_uri.hostname, api_uri.port, use_ssl: true) { |http| http.request(request) }
    parsed_response = JSON.parse(response.body)
    Rails.logger.info("RESPONSE FROM GITHUB: #{response}") unless parsed_response.is_a?(Array)
    parsed_response
  end
  private_class_method :github_api_get

  def self.github_labels_for_pull_request(repository, number)
    github_api_get("https://api.github.com/repos/#{repository}/issues/#{number}/labels")
  end
  private_class_method :github_labels_for_pull_request
end
