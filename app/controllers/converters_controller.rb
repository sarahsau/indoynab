class ConvertersController < ApplicationController
  def index
    @converter = Converter.new
  end

  def create
    @converter = Converter.new(converter_params)
    result = @converter.run_conversion
    file_path = Rails.root.join('public', 'output', result)
    delete_statement(file_path)
  end

  def faq
    render 'converters/faq'
  end

  private

  def converter_params
    params.require(:converter).permit(:bank, :statement)
  end

  def delete_statement(file_path)
    File.open(file_path, 'r') do |f|
      send_data(f.read, filename: 'indoynab.csv', type: 'text/csv')
    end

    File.delete(file_path)
  end
end
