class ConvertersDropResult < ActiveRecord::Migration[6.1]
  def self.up
    remove_column :converters, :result
  end
end
