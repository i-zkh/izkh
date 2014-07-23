class ChangeTypeOfBodyInUserFeedback < ActiveRecord::Migration
  def change
    change_column :user_feedbacks, :body, :text
  end
end
