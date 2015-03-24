class OrganisationAdminsController < ApplicationController

  def new_contact
    @organisation = Organisation.find(params[:organisation_id])
    @email = params[:email]
  end

  def contact
    @organisation = Organisation.find(params[:organisation_id])
    user = User.where(organisation_id: @organisation.id).first
    help_email = OrganisationAdminMailer.help_request(user, @organisation, params[:message], params[:email])
    help_email.deliver
    redirect_to new_user_registration_path, notice: "A message was sent to the admin of #{@organisation.title}"
  end

end