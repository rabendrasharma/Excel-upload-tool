require 'csv'

class Product < ApplicationRecord
  # validates_presence_of :price
  
  # def self.to_csv(options = {})
  #   desired_columns = ["id", "name", "released_on", "price"]
  #   CSV.generate(options) do |csv|
  #     csv << desired_columns
  #     all.each do |product|
  #       csv << product.attributes.values_at(*desired_columns)
  #     end
  #   end
  # end
  
  def self.import(file)
    raise "Products import failed, file size exceeded. File size should be less then 10 mb" unless file.size < 10000001
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    a = ["name", "released_on", "price"] - header
    raise "File can not be parse due to different header name  you can use header name like name, released_on, price" unless a.blank?
    rows = []
    (2..spreadsheet.last_row).each do |i|
      rows << Hash[[header, spreadsheet.row(i)].transpose]
    end
    ApplicationJob.perform_later(rows.to_json)
  end  
end