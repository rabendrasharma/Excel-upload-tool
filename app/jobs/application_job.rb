require 'csv'
class ApplicationJob < ActiveJob::Base
	queue_as :default

  def perform(*args)
  	rows = JSON.parse args[0]
  	ActiveRecord::Base.transaction do 
  		rows.each do |row|
	  	  product = Product.find_by(id: row["id"]) || Product.new
	      product.attributes = row.to_hash
	      product.save!
    	end
    end
  end
end
