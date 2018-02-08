# frozen_string_literal: true

class AddSprintIdToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :sprint_id, :integer
  end
end
