class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :postal_code
      t.string :address
      t.text :self_introduction
    end

    create_table :reports do |t|
      t.belongs_to :user
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
