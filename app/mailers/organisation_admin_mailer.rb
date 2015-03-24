class OrganisationAdminMailer < ApplicationMailer

  default from: 'notifications@example.com'
 
  def help_request(user, organisation, message, requester_email)
    @user = user
    @organisation = organisation
    @message = message
    @requester_email = requester_email

    mail(to: @user.email, subject: "A user would like to help with #{@organisation.title}'s Open Data Maturity")   
  end

end
