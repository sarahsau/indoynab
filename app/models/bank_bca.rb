require_relative 'bank_all'
require 'csv'

class BankCentralAsia < BankAll
	attr_accessor :input, :year, :output, :errors

	def initialize(input, year, output)
		@input = input
		@year = year
		@output = output
	end

	def bca_processing_csv
		CSV.foreach(self.input, skip_lines:/Balance/, skip_blanks: true) do |row|

			# Ignore four beginning and ending rows and also pending transactions.
			date = row[0].to_s
			if date.include?('PEND') || date.include?('Name') || date.include?('Balance') || date.include?('Currency') || date.include?('Account') || date.include?('Credit') || date.include?('Debet')
				next
			end

			# Format date in the first column, assuming that all transactions occur in the same year.

			annoying_first_character = date.chr
			date.delete!(annoying_first_character)
			date_with_year = date.dup.insert(-1, '/' + self.year.to_s)

			unless date_with_year == "/#{self.year}"
				row[0] = date_with_year
			end

			# Delete 'branch' and 'running balance' columns.
			 row.delete(row[2])
			 row.delete(row[4])

			# assign credit and debit to transactions
			if row[3].to_s.include?('DB')
				outflow = 0 - row[2].to_f
				row[2].replace(outflow.to_s)
			end

			# Delete CR and DB.
			row.delete(row[3])

			# Move columns to the correct headers.
			row[3] = row[2]
			row[2] = row[1]
			row[1] = ""

		# Insert results to the new file
			CSV.open(self.output, "a+") do |csv|
				csv << row
			end
		end
	end

	def bca_processing_pdf
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
		      ary = s.split("\s\s\s\s")

					# delete empty rows
					ary.each(&:strip!)
					ary.delete_if { |str| str.nil? || str.empty? }

					# Delete page headers
					unless ary[0].nil?
						ary.clear if ary[0].length != 5
					end

					# Delete saldo awal
					ary.clear if ary[1] == "SALDO AWAL"

					# delete extra rows
					rows << ary if ary.any?
		    end

				pages << rows
      end

		  # Formatting to YNAB CSV format
		    pages.each do |page|
            page.each do |rows|

					# uniform row length
					rows.delete_at(-1) if rows[1] == "PAJAK BUNGA"

					if rows[3] != nil && rows[3].length == 4
						rows.delete_at(3) if rows[3][0] == "0"
					end

					# add empty memo
					if rows.length < 4
						rows[3] = rows[2]
						rows[2] = 'NaN'
					end

					# delete saldo
					rows.delete_at(-1) if rows.length > 4

		      # swap memo with payee
					payee_col = rows[2]
					memo_col  = rows[1]

		      rows[2] = memo_col
		      rows[1] = payee_col

		      # Make outflows negative.
					 if rows[3].include? "DB"
					 	rows[3].prepend "-"
					 	rows[3].chop!.chop!.chop!
					 end

					# Add year
					rows[0].concat('/', self.year)

					# Insert transactions into the resulting CSV file.
		      CSV.open(self.output, "a+") do |csv|
		        csv << rows
          end
		    end
		  end
		end
  end
end
