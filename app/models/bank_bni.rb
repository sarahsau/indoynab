require_relative 'bank_all'
require 'csv'
require 'pdf-reader'

class BankNegaraIndonesia < BankAll
	attr_accessor :input, :output, :errors

	def initialize(input, output)
		@input = input
		@output = output
	end

	def bni_processing
		File.open(self.input, 'rb') do |io|
		  reader = PDF::Reader.new(io)
		  pages = []

		  # Parsing PDF
		  reader.pages.each do |page|
		    rows = []

		    # Separating a whole text
		    t = page.text.split("\n")

		    t.each do |s|

		      # Formatting - remove whitespace,  empty cells, 'Tanpa Kategori' column, and header
		      ary = s.split("\s\s")

					ary.each(&:strip!)

          # Delete headers
          headers = [ 'HISTORI TRANSAKSI', 'Kriteria Pencarian',
                      'Transactions List', 'Transaksi']

          headers.each do |header|
            if ary.to_s.match(/\b#{header}\b/i)
              ary.clear
            end
          end

		      ary.delete_if { |str| str.nil? || str.empty? || str == "Tanpa Kategori" }
		      rows << ary
		    end

		    pages << rows
      end

		  # Formatting to YNAB CSV format
		    pages.each do |page|

		      # Remove non-transactions
            page.each do |rows|
              unless rows.include?('Db.') || rows.include?('Cr.') # || (!rows.empty? && rows.count == 1)
                next
            end

		      # Delete Saldo' and 'Pecah Transaksi' columns
          if rows.count > 1
            rows.delete(rows[4])
  				 	rows.delete(rows[5])
          end

		      # Insert blank 'Payee' column.
		      rows[4] = rows[3]
		      rows[3] = rows[2]
		      rows[2] = rows[1]
		      rows[1] = ""

		      # Make outflows negative.
		      if rows[3].to_s.include?('Db.')
						amount = rows[4].delete(",").to_f
		      	outflow = (0 - amount)
		      	rows[4].replace(outflow.to_s)
					elsif rows[3].to_s.include?('Cr.')
						inflow = rows[4].delete(",").to_f
						rows[4].replace(inflow.to_s)
		      end

		      # Delete CR and DB.
		      rows.delete(rows[3])

		      # Format date column
          month = { '-jan-' => '/01/', '-Feb-' => '/02/', '-Mar-' => '/03/',
                    '-Apr-' => '/04/', '-May-' => '/05/', '-Jun-' => '/06/',
                    '-Jul-' => '/07/', '-Aug-' => '/08/', '-Sep-' => '/09/',
                    '-Oct-' => '/10/', '-Nov-' => '/11/', '-Dec-' => '/12/' }

          month.each do |k, v|
            rows[0].gsub!(k, v)
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
