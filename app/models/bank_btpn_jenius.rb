require_relative 'bank_all'
require 'csv'
require 'pdf-reader'

class BtpnJenius < BankAll
	attr_accessor :input, :output, :errors

	def initialize(input, output)
		@input = input
		@output = output
	end

	def btpn_processing
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

          # select transactions with amount
          if ary.to_s.include? "+ "
            ary
          elsif ary.to_s.include? "- "
            ary
          else
            next
          end

          # for test only: add note column if empty
          ary.insert(1, "Transaction notes") if ary.count == 2

          rows << ary
		    end
		    pages << rows
      end

		  # Formatting to YNAB CSV format
		    pages.each do |page|
          page.each do |rows|

		      # Insert blank 'Payee' column.
		      rows[3] = rows[2]
		      rows[2] = rows[1]
		      rows[1] = ""

		      # Format transaction amount
          rows[3].delete!(",")

		      if rows[3].to_s.include? "+"
            rows[3].delete_prefix! "+ "
					else
            rows[3].delete_prefix! "- "
            amount = (0 - rows[3].to_f)
            rows[3].replace(amount.to_s)
		      end

		      # Format date column
          month = { 'Jan' => '/01/', 'Feb' => '/02/', 'Mar' => '/03/',
                    'Apr' => '/04/', 'May' => '/05/', 'Jun' => '/06/',
                    'Jul' => '/07/', 'Aug' => '/08/', 'Sep' => '/09/',
                    'Oct' => '/10/', 'Nov' => '/11/', 'Dec' => '/12/' }

          month.each do |k, v|
            rows[0].gsub!(k, v)
            rows[0].delete! " "
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
