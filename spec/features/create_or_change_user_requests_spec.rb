require 'rails_helper'

feature "Create or change user requests" do
  # In order to allow departments to shift responsibilities around
  # As a departmental user manager
  # I want to request GDS tool access or new permissions for other users

  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "user creation request" do
    zendesk_has_no_user_with_email("bob@gov.uk")

    ticket_request = expect_zendesk_to_receive_ticket(
      "subject" => "New user account",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w{govt_form create_new_user inside_government},
      "comment" => { "body" =>
"[Action]
New user account

[User needs]
Departments and policy editor permissions, Departments and policy writer permissions

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Requested user's job title]
Editor

[Requested user's phone number]
12345

[Additional comments]
XXXX"})

    user_creation_request = stub_zendesk_user_creation(
      email: "bob@gov.uk",
      name: "Bob Fields",
      details: "Job title: Editor",
      phone: "12345",
      verified: true,
    )

    user_requests_a_change_to_user_accounts(
      action: "New user account",
      user_needs: [ "Departments and policy writer permissions", "Departments and policy editor permissions" ],
      user_name: "Bob Fields",
      user_email: "bob@gov.uk",
      user_job_title: "Editor",
      user_phone: "12345",
      additional_comments: "XXXX",
    )

    expect(ticket_request).to have_been_made
    expect(user_creation_request).to have_been_made
  end

  scenario "changing user permissions" do
    zendesk_has_user(email: "bob@gov.uk", name: "Bob Fields")

    ticket_request = expect_zendesk_to_receive_ticket(
      "subject" => "Change an existing user's permissions",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w{govt_form change_user},
      "comment" => { "body" =>
"[Action]
Change an existing user's permissions

[User needs]
Other/Not sure

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Additional comments]
XXXX"})

    user_requests_a_change_to_user_accounts(
      action: "Change an existing user's permissions",
      user_needs: [ "Other/Not sure" ],
      user_name: "Bob Fields",
      user_email: "bob@gov.uk",
      additional_comments: "XXXX",
    )

    expect(ticket_request).to have_been_made
  end

  private
  def user_requests_a_change_to_user_accounts(details)
    visit '/'

    click_on "Create or change user"

    expect(page).to have_content("Create or change a user account")

    within "#action" do
      choose details[:action]
    end

    within "#user-needs" do
      details[:user_needs].each { |user_need| check user_need }
    end

    within("#user_details") do
      fill_in "Name", with: details[:user_name]
      fill_in "Email", with: details[:user_email]
      fill_in "Job title", with: details[:user_job_title] if details[:user_job_title]
      fill_in "Phone number", with: details[:user_phone] if details[:user_phone]
    end

    fill_in "Additional comments", with: details[:additional_comments]

    user_submits_the_request_successfully
  end
end
