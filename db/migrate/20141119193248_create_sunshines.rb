class CreateSunshines < ActiveRecord::Migration
  def change
    create_table :sunshines do |t|

      t.timestamps
    end
  end
end
