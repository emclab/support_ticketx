class CreateSupportTicketxIssues < ActiveRecord::Migration
  def change
    create_table :support_ticketx_issues do |t|
      t.string :subject
      t.text :description

      t.timestamps
    end
  end
end
