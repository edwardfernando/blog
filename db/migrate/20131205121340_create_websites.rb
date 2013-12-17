class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :url
      t.string :title
      t.text :content

      t.references :user, index: true

      t.timestamps
    end
  end
end
