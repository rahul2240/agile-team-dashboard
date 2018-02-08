# frozen_string_literal: true

class AddNameToSprint < ActiveRecord::Migration[5.0]
  def change
    add_column :sprints, :name, :string
  end
end
