class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :url
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
