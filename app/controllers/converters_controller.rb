class ConvertersController < ApplicationController

  def index
    @converter = Converter.new
  end

  def show
    redirect_to root_path
  end

  def create
    @converter  = Converter.new(converter_params)

    if converter_params[:statement].nil?
      flash.now[:alert] = "Error: no statement provided"
    # elsif !(format_ok?(converter_params[:statement]))
    #  flash.now[:alert] = "Error: wrong file type"
    #  render action: "index"
    else
      result      = @converter.run_conversion
      file_path   = Rails.root.join('public', 'output', result)

      flash.now[:success] = "Conversion successful!"
      stream_then_delete_statement(file_path)
    end
  end

  def faq
    render 'converters/faq'
  end

  private

  def converter_params
    params.require(:converter).permit(:bank, :statement)
  end

  def format_ok?(statement_params)
    pdf_statement = [ "bni" ]
    csv_statement = [ "bca" ]

    if pdf_statement.include? statement_params
      p statement_params
    elsif csv_statement.include? statement_params
      statement_params.content_type.csv_check?
    else
      return
    end
  end

  def stream_then_delete_statement(file_path)
    File.open(file_path, 'r') do |f|
      send_data(f.read, filename: 'indoynab.csv', type: 'text/csv')
    end

    File.delete(file_path)
  end
end
