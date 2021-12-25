require_relative 'bank_all'
require 'csv'
require 'pdf-reader'

class BankSyariahIndonesia < BankAll
	attr_accessor :input, :output, :errors

	def initialize(input, output)
		@input = input
		@output = output
	end

	def bsi_processing
		File.open(self.input, 'rb') do |io|
		  reader = PDF::Reader.new(io)
		  pages = []

		  # Parsing PDF
		  reader.pages.each do |page|
		    rows = []

		    # Separating a whole text
		    t = page.text.split("\n")

		    t.each do |s|

		      # Remove whitespace and empty cells
		      ary = s.split("\s\s")

					# delete empty rows
					ary.each(&:strip!)
					ary.delete_if { |str| str.nil? || str.empty? }

          # Delete page headers
          pg_headers = ['MUTASI REKENING', 'Rekening\t\t\t:', 'Cabang:\t\t\t\t',
                      'Periode\t\t\t\t:', 'Total Debet (dlm Periode)\t:',
										  'Total Kredit (dlm Periode)\t:', 'Saldo rill awal per\t\t:',
										  'Saldo rill akhir per\t\t:']

          pg_headers.each do |header|
            if ary.to_s.include?(header)
              ary.clear
            end
          end

					# Delete column headers
					col_header1 = ["No", "Waktu", "No. Referensi", "Nama", "Bank", "Nama", "Bank", "Deskripsi", "Debit", "Kredit", "Saldo Riil", "Kode"]
					col_header2 = ["Transaksi", "Pengirim", "Pengirim", "Penerima", "Penerima"]

					if ary == col_header1 || ary == col_header2
						ary.clear
					end

					# delete extra rows
					rows << ary if ary.any? && ary[0].length <= 2
		    end

				pages << rows
      end

		  # Formatting to YNAB CSV format
		    pages.each do |page|
            page.each do |rows|

		      # Delete unused columns
						rows.delete_at(-1) # code
            rows.delete_at(0) # numbering
  				 	rows.delete_at(1) # referensi
						rows.delete_at(1) # nama
						rows.delete_at(1) # bank
						rows.delete_at(-1) # saldo riil

						date_col = rows[0]
						memo_col = rows[1]
						amount_col = rows[-1]

		      # Insert blank 'Payee' column.
					rows.clear
		      rows[3] = amount_col
		      rows[2] = memo_col
		      rows[1] = ""
					rows[0] = date_col

		      # Make outflows negative.

		      if rows[3].to_s.include?('-')
						amount  = rows[3].delete!("-").delete!(",").to_f
		      	outflow = (0 - amount)

						rows[3].replace(outflow.to_s)
					else
						rows[3].delete!(".00").delete!(",")
		      end

					# Insert transactions into the resulting CSV file.
		      CSV.open(self.output, "a+") do |csv|
		        csv << rows
          end
		    end
		  end
		end
  end
end
