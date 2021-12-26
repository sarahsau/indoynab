class AddStatementYearToConverters < ActiveRecord::Migration[6.1]
  def change
    add_column :converters, :statement_year, :integer
  end
end
