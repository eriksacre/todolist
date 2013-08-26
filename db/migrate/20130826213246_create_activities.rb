class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user
      t.string :action
      t.datetime :recorded_at
      t.text :info
    end
  end
end
