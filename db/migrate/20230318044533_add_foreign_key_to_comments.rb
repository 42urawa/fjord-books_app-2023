class AddForeignKeyToComments < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :comments, :books, column: :commentable_id, on_delete: :cascade # on_delete: :cascadeを追加する
    add_foreign_key :comments, :reports, column: :commentable_id, on_delete: :cascade # on_delete: :cascadeを追加する
  end
end
