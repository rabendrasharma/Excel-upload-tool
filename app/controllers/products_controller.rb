class ProductsController < ApplicationController
  def index
    @products = Product.order(:name)
    respond_to do |format|
      format.html
      # format.csv { send_data @products.to_csv }
      format.xls 
    end
  end
  
  def import
    begin
      Product.import(params[:file])
      redirect_to root_url, notice: 'Products import is on queue.'
    rescue ArgumentError => e
      flash[:error] = "You can upload only .xlsx"
      redirect_to root_url
    rescue Exception => e
      flash[:error] = "#{e.message}"
      redirect_to root_url
    end
  end
end
