class CreateConverters < ActiveRecord::Migration[6.1]
  def change
    create_table :converters do |t|
      t.string :banks
      t.binary :files
      t.binary :results
      t.timestamps
    end
  end
end
