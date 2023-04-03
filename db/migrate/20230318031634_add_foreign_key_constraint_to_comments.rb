class AddForeignKeyConstraintToComments < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :comments, :users # 元々の外部キー制約を削除する
    add_foreign_key :comments, :users, on_delete: :cascade # on_delete: :cascadeを追加する
  end
end
