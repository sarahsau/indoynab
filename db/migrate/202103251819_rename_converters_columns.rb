class RenameConvertersColumns < ActiveRecord::Migration[6.1]
  def self.up
    rename_column :converters, :banks, :bank
    rename_column :converters, :files, :statement
    rename_column :converters, :results, :result
  end
end
