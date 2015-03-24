class OrganisationAdminsController < ApplicationController

  def new_contact
    @organisation = Organisation.find(params[:organisation_id])
    @email = params[:email]
  end

  def contact
    @organisation = Organisation.find(params[:organisation_id])
    render text: "A message was sent to the admin of #{@organisation.title}"
  end

end