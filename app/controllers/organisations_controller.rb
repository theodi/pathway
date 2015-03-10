class OrganisationsController < ApplicationController

  respond_to :json

  def index
    @organisations = Organisation.where("name LIKE (?)", "%#{params[:q]}%")
    respond_with @organisations
  end

end
