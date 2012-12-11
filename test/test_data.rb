module TestData
  def valid_create_new_user_request_params
    { "create_new_user_request" =>
      { "requester_attributes" => valid_requester_params,
        "requested_user_attributes" => valid_requested_user_params,
        "tool_role" => "govt_form",
        "additional_comments"=>"" }
    }
  end

  def valid_general_request_params
    {"general_request" => 
      { "requester_attributes" => valid_requester_params,
        "url"=>"testing",
        "additional"=>"" }
    }
  end

  def valid_requester_params
    { "email"=>"testing@digital.cabinet-office.gov.uk" }
  end

  def valid_requested_user_params
    {
      "name"=>"subject",
      "email"=>"subject@digital.cabinet-office.gov.uk",
      "job"=>"editor",
      "phone"=>"12345",
    }    
  end
end
