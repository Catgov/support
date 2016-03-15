class ZendeskTicketWorker
  include Sidekiq::Worker

  def perform(ticket_options)
    if GDS_ZENDESK_CLIENT.users.suspended?(ticket_options["requester"]["email"])
      $statsd.increment("#{::STATSD_PREFIX}.report_a_problem.submission_from_suspended_user")
    else
      begin
        create_ticket(ticket_options)
      rescue ZendeskAPI::Error::NetworkError => e
        raise unless e.response.status == 409
      end
    end
  end

private
  def create_ticket(ticket_options)
    GDS_ZENDESK_CLIENT.ticket.create!(HashWithIndifferentAccess.new(ticket_options))
  end
end
