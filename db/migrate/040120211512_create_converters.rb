class CreateConverters < ActiveRecord::Migration[6.1]
  def change
    create_table :converters do |t|
      t.string :bank
      t.binary :input
      t.binary :output
      t.timestamps
    end
  end
end
