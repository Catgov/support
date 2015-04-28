require 'rails_helper'

feature "User satisfaction survey submissions" do
  # In order to fix and improve my service (that's linked on GOV.UK)
  # As a service manager
  # I want to record and view bugs, gripes and improvement suggestions submitted by the service users

  background do
    login_as create(:user)
    the_date_is("2013-02-28")
  end

  scenario "submission with comment" do
    create(:service_feedback,
      slug: "find-court-tribunal",
      path: "/done/find-court-tribunal",
      service_satisfaction_rating: 3,
      details: "Make service less 'meh'",
      user_agent: "Safari",
      javascript_enabled: true,
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/done/find-court-tribunal")

    expect(feedex_results).to eq([
      {
        "Date" => "28 February 2013",
        "Feedback" => "rating: 3 comment: Make service less 'meh'",
        "URL" => "/done/find-court-tribunal",
        "Referrer" => "–"
      }
    ])
  end

  scenario "submission without a comment" do
    create(:service_feedback,
      slug: "apply-carers-allowance",
      path: "/done/apply-carers-allowance",
      service_satisfaction_rating: 3,
      details: nil,
      javascript_enabled: true,
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/done/apply-carers-allowance")

    expect(feedex_results.first["Feedback"]).to eq("rating: 3")
  end

  private
  def the_date_is(date_string)
    Timecop.travel Date.parse(date_string)
  end
end
