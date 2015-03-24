class OrganisationAdminsController < ApplicationController

  def new_contact
    @organisation = Organisation.find(params[:id])
    @email = params[:email]
  end

  def contact
    @organisation = Organisation.find(params[:id])    
  end

end
