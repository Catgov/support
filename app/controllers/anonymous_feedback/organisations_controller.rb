require "gds_api/support_api"

class AnonymousFeedback::OrganisationsController < AuthorisationController
  def show
    authorize! :read, :anonymous_feedback

    if %w(path last_7_days last_30_days last_90_days).include? params[:ordering]
      @ordering = params[:ordering]
    else
      @ordering = 'last_7_days'
    end

    api_response = fetch_organisation_summary_from_support_api(@ordering)

    @organisation_title = api_response["title"]
    @content_items = OrganisationSummaryPresenter.new(api_response)
  end

private
  def fetch_organisation_summary_from_support_api(ordering)
    support_api.organisation_summary(params[:slug], ordering: ordering)
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
