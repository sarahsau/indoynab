class Converter < ActiveRecord::Base

  require_relative 'lib/bca'
  require_relative 'lib/bni'

  def run_conversion
    bank            = self[:bank]
    file            = self[:statement]
    statement_year  = self[:statement_year] || "#{Time.now.year}"
    output          = "public/output/#{bank}_indoynab_#{SecureRandom.alphanumeric}.csv"

    case bank
    when /bca/i
      statement = BankCentralAsia.new(file, statement_year, output)

      statement.output_file
      statement.bca_processing
      statement.assign_payee
      return statement.output_name

    when /bni/i
      statement = BankNegaraIndonesia.new(file, output)

      statement.output_file
      statement.bni_processing
      statement.assign_payee
      return statement.output_name
    end
  end
end