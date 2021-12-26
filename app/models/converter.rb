class Converter < ApplicationRecord

  require_relative 'bank_bca'
  require_relative 'bank_bni'
  require_relative 'bank_bsi'
  require_relative 'bank_btpn_jenius'

  def run_conversion
    bank            = self[:bank]
    file            = self[:statement]
    statement_year  = self[:statement_year]
    output          = "public/output/#{bank}_indoynab_#{SecureRandom.alphanumeric}.csv"

    case bank
    when "bca_csv"
      statement = BankCentralAsia.new(file, statement_year, output)

      statement.output_file
      statement.bca_processing_csv
      statement.assign_payee
      return statement.output_name

    when "bca_pdf"
      statement = BankCentralAsia.new(file, statement_year, output)

      statement.output_file
      statement.bca_processing_pdf
      statement.assign_payee
      return statement.output_name

    when "bni"
      statement = BankNegaraIndonesia.new(file, output)

      statement.output_file
      statement.bni_processing
      statement.assign_payee
      return statement.output_name

    when "bsi"
      statement = BankSyariahIndonesia.new(file, output)

      statement.output_file
      statement.bsi_processing
      statement.assign_payee
      return statement.output_name

    when "btpn_jenius"
      statement = BtpnJenius.new(file, output)

      statement.output_file
      statement.btpn_processing
      statement.assign_payee
      return statement.output_name
    end
  end
end
