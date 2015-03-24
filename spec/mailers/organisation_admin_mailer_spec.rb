require "spec_helper"

describe OrganisationAdminMailer do
  
  it "sends an email" do
    organisation = FactoryGirl.create(:organisation)
    user = FactoryGirl.create(:user, organisation_id: organisation.id)
    message = "Can you get in touch?"
    requester_email = "arequester@example.com"
    help_email = OrganisationAdminMailer.help_request(user, organisation, message, requester_email)
    expect { help_email.deliver }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

end
