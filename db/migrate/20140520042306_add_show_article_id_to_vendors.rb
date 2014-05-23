class AddShowArticleIdToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :shop_article_id, :integer
  end
end
