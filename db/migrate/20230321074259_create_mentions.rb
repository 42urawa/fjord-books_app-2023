class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :mentioning_id
      t.integer :mentioned_id

      t.timestamps
    end
    add_index :mentions, [:mentioning_id, :mentioned_id], unique: true
  end
end
