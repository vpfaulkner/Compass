class CreateLegislatures < ActiveRecord::Migration
  def change
    create_table :legislatures do |t|

      t.timestamps
    end
  end
end
