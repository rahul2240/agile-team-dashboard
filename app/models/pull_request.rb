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
end
