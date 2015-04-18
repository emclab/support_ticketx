FactoryGirl.define do
  factory :support_ticketx_support_ticket, :class => 'SupportTicketx::SupportTicket' do
    description           "MyString"
    urgency               "High"
    app_id                1
    requested_date        "2015-01-27"
    requested_by_id       1
    last_updated_by_id    1
    contact_name          "MyName"
    contact_email         "me@abc.com"
    contact_phone_number  "123-1234-1234"
    assigned_to_id        1
    external_ticket_id    1
    wf_state              "initial_state"
    resolution            "Resolved"
    resolution_date       "2015-01-27"
    uploaded_files        "\\direct"
    
  end

end
