class OrganisationsController < ApplicationController

  respond_to :json

  def index
    query = params[:q].to_s
    @organisations = Organisation.where("name LIKE (?)", "%#{query.downcase}%")
    respond_with @organisations
  end

end
