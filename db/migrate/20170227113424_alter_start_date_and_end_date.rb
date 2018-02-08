# frozen_string_literal: true

class AlterStartDateAndEndDate < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :start_date, :datetime
    change_column :events, :end_date, :datetime
  end
end
