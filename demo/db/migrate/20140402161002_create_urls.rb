class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.text :k
      t.text :v
      t.timestamps
    end
  end
end