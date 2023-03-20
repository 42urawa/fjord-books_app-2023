class RemoveForeignKeyToComments < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key "comments", "books", column: "commentable_id", on_delete: :cascade
    remove_foreign_key "comments", "reports", column: "commentable_id", on_delete: :cascade
  end
end
