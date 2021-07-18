class Converter < ApplicationRecord

  require_relative 'bank_bca'
  require_relative 'bank_bni'


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

    when /btpn_jenius/i
      statement = BtpnJenius.new(file, output)

      statement.output_file
      statement.bni_processing
      statement.assign_payee
      return statement.output_name
    end
  end
end
