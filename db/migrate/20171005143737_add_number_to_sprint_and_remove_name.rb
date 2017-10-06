class AddNumberToSprintAndRemoveName < ActiveRecord::Migration[5.1]
  def up
    add_column :sprints, :number, :integer
    remove_column :sprints, :name, :string

    execute 'UPDATE sprints SET number = id WHERE number is null'

    change_column_null :sprints, :number, false
  end

  def down
    add_column :sprints, :name, :string
    remove_column :sprints, :number, :integer, null: false
  end
end
