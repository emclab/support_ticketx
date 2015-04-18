# This migration comes from support_ticketx (originally 20150125163303)
class CreateSupportTicketxSupportTickets < ActiveRecord::Migration
  def change
    create_table :support_ticketx_support_tickets do |t|

      t.date            :requested_date
      t.integer         :requested_by_id
      t.text            :description
      t.string          :urgency
      t.integer         :app_id
      t.integer         :contact_id
      t.text            :resolution
      t.date            :resolution_date
      t.integer         :external_ticket_id
      t.string          :wf_state
      t.text            :uploaded_files
      t.integer         :last_updated_by_id
      t.timestamps
    end

  end
end
