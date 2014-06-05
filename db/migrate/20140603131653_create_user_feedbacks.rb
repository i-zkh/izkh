class CreateUserFeedbacks < ActiveRecord::Migration
  def change
    create_table :user_feedbacks do |t|
      t.string :topic
      t.string :body
      t.integer :user_id
      t.string :new_version

      t.timestamps
    end
  end
end
