class CreateSupportTicketxSupports < ActiveRecord::Migration
  def change
    create_table :support_ticketx_supports do |t|

      t.timestamps
    end
  end
end
