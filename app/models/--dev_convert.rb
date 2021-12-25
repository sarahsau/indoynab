require_relative 'bank_bca'
require_relative 'bank_bni'
require_relative 'bank_bsi'
require_relative 'bank_btpn_jenius'


bank            = ARGV[0]
file            = ARGV[1]
statement_year  = ARGV[2]
output          = ARGV[3]

case bank
when "bca_csv"
  statement = BankCentralAsia.new(file, statement_year, output)

  statement.output_file
  statement.bca_processing
  statement.assign_payee

when "bni"
  statement = BankNegaraIndonesia.new(file, output)

  statement.output_file
  statement.bni_processing
  statement.assign_payee

when "bsi"
  statement = BankSyariahIndonesia.new(file, output)

  statement.output_file
  statement.bsi_processing
  statement.assign_payee

when "btpn_jenius"
  statement = BtpnJenius.new(file, output)

  statement.output_file
  statement.btpn_processing
  statement.assign_payee
end
