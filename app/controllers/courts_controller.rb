class CourtsController < ApplicationController
  def show
    @court = Court.find(params[:id])
    store_location
  end
end
