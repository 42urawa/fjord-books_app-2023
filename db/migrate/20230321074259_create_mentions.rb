class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :mentioning_id, null: false
      t.integer :mentioned_id, null: false

      t.timestamps
    end
    add_index :mentions, [:mentioning_id, :mentioned_id], unique: true
    add_index :mentions, [:mentioned_id, :mentioning_id], unique: true
  end
end
