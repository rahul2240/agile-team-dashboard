class PagesController < ApplicationController
  PAGES = %i(sample).freeze

  PAGES.each do |action_name|
    define_method(action_name) do
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      @content = markdown.render(File.open(Rails.root.join('pages', "#{action_name}.md")).read)

      render :show
    end
  end
end
