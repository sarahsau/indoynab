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
      render action: "index"
    # elsif converter_params[:statement].file_check
    #   flash.now[:alert] = "Error: wrong file type"
    #   render action: "index"
    else
      result      = @converter.run_conversion
      file_path   = Rails.root.join('public', 'output', result)

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

  def file_check
    pdf_statement = [ "bni" ]
    csv_statement = [ "bca" ]

    if pdf_statement.include? converter_params[:bank]
      self.content_type.pdf_check?
    elsif csv_statement.include? converter_params[:bank]
      self.content_type.csv_check?
    else
      exit(0)
    end
  end

  def stream_then_delete_statement(file_path)
    File.open(file_path, 'r') do |f|
      send_data(f.read, filename: 'indoynab.csv', type: 'text/csv')
    end

    File.delete(file_path)
  end
end
