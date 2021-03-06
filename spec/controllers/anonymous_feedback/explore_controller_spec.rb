require 'rails_helper'
require 'gds_api/test_helpers/support_api'

describe AnonymousFeedback::ExploreController, :type => :controller do
  include GdsApi::TestHelpers::SupportApi
  before do
    stub_organisations_list([
      {
        slug: "cabinet-office",
        web_url: "https://www.gov.uk/government/organisations/cabinet-office",
        title: "Cabinet Office",
        acronym: "CO",
        govuk_status: "live"
      },{
        slug: "ministry-of-magic",
        web_url: "https://www.gov.uk/government/organisations/ministry-of-magic",
        title: "Ministry of Magic",
        acronym: "",
        govuk_status: "transitioning"
      }
    ])

    login_as create(:user, organisation_slug: "cabinet-office")
  end

  it "shows the new form again for invalid requests" do
    post :create, { support_requests_anonymous_explore_by_url: { url: "" } }
    expect(response).to have_http_status(422)
    expect(assigns(:explore_by_url)).to be_present
  end

  context "#new" do
    before do
      get :new
    end

    it "defaults to the user's organisation" do
      expect(assigns(:explore_by_organisation).organisation).to eq("cabinet-office")
    end

    it "lists the available organisations" do
      expect(assigns(:organisations_list)).to eq([
        ["Cabinet Office (CO)", "cabinet-office"],
        ["Ministry of Magic [Transitioning]", "ministry-of-magic"]
      ])
    end
  end

  context "with a successful request" do
    context "when exploring by URL" do
      it "redirects to the anonymous feedback index page" do
        post :create, { support_requests_anonymous_explore_by_url: { url: "https://www.gov.uk/tax-disc" } }
        expect(response).to redirect_to("/anonymous_feedback?path=%2Ftax-disc")
      end
    end

    context "when exploring by organisation" do
      let(:org) { "department-of-fair-dos" }
      let(:attributes) { {organisation: org} }
      let(:redirect_path) { "/anonymous_feedback/organisations/#{org}" }

      it "redirects to anonymous_feedback/organisations#show" do
        post :create,
          { support_requests_anonymous_explore_by_organisation: attributes }

        expect(response).to redirect_to(redirect_path)
      end
    end
  end
end
