class CountriesController < ApplicationController
  respond_to :json

  def index
    query = params[:q].to_s

    @countries = Country.where("LOWER(name) LIKE (?)", "%#{query.downcase}%")
    respond_with @countries
  end

end
