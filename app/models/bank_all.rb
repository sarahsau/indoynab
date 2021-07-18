require 'csv'
require 'fileutils'

class BankAll

  def pdf_check?
    self == "application/pdf"
  end

  def csv_check?
    self == "application/csv"
  end

	def output_file
		CSV.open(self.output, 'wb') do |csv|
			csv << ["Date", "Payee", "Memo", "Amount"]
		end
	end

	def assign_payee
		CSV.foreach(self.output, 'rb+', skip_blanks: true) do |row|
			memo_column = row[2].to_s
			payee_column = row[1].to_s

			companies = ['shopee', 'tokopedia', 'ovo', 'sayurbox', 'gopay', 'fave']

			companies.each do |company|
				if memo_column.match(/#{company}/i) && payee_column.empty?
					payee_column << company.to_s
				end
			end

			if self.class == BankCentralAsia
				bca_activities = ['bunga', 'pajak bunga', 'biaya adm']

				bca_activities.each do |activity|
					if memo_column.match(/\b#{activity}\b/i)
						payee_column << "BCA" unless !payee_column.empty?
					end
				end

			elsif self.class == BankNegaraIndonesia
				bni_activities = ['pph', 'bagihasil/bonus', 'biaya adm rek']

				bni_activities.each do |activity|
					if memo_column.match(/\b#{activity}\b/i)
						payee_column << "BNI" unless !payee_column.empty?
					end
				end

      elsif self.class == BtpnJenius
        btpn_jenius_activities = ['Insufficient funds fee', 'Tax on interest', 'Interest']

        btpn_jenius_activities.each do |activity|
          if memo_column.match(/\b#{activity}\b/i)
            payee_column << "BTPN Jenius" unless !payee_column.empty?
          end
        end

			else
				next
			end

			# output to console
			p row
		end
	end

  def output_name
    output.delete_prefix("public/output/")
  end
end
