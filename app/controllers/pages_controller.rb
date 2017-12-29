class PagesController < ApplicationController
  PAGES = { build_solutions_team: 'Team Info' }.freeze

  PAGES.each_key do |action_name|
    define_method(action_name) do
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
      @content = markdown.render(File.open(Rails.root.join('pages', "#{action_name}.md")).read)

      render :show
    end
  end
end
