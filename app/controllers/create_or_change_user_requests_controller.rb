require 'zendesk/ticket/create_or_change_user_request_ticket'
require 'support/requests/create_or_change_user_request'
require 'gds_zendesk/users'
require 'zendesk_api/error'

class CreateOrChangeUserRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    CreateOrChangeUserRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::CreateOrChangeUserRequestTicket
  end

  def parse_request_from_params
    CreateOrChangeUserRequest.new(create_or_change_user_request_params)
  end

  def create_or_change_user_request_params
    params.require(:support_requests_create_or_change_user_request).permit(
      :action, :additional_comments,
      :user_needs, :mainstream_changes, :maslow, :other_details,
      requester_attributes: [:email, :name, :collaborator_emails],
      requested_user_attributes: [
        :name,
        :email,
        :job,
        :phone,
        :other_training,
        training: []
      ]
    )
  end

  def save_to_zendesk(submitted_request)
    super
    create_or_update_user_in_zendesk(submitted_request.requested_user) if submitted_request.for_new_user?
  end

  def create_or_update_user_in_zendesk(requested_user)
    begin
      GDS_ZENDESK_CLIENT.users.create_or_update_user(requested_user)
    rescue ZendeskAPI::Error::ClientError => e
      exception_notification_for(e)
    end
  end
end
