class CreateActivityRelations < ActiveRecord::Migration
  def change
    create_table :activity_relations do |t|
      t.references :activity
      t.string :action
      t.datetime :recorded_at
      t.integer :related_id
      t.string :related_type
    end
    add_index :activity_relations, [:related_id, :related_type, :recorded_at], name: "activity_relations_related"
  end
end
