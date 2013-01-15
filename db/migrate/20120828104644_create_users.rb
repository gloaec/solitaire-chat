class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.binary :deck
      t.timestamps
    end
  end
end
