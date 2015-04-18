require 'spec_helper'

describe "IssuesIntegrations" do
  describe "GET /support_ticketx_issues_integrations" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get support_ticketx_issues_integrations_path
      response.status.should be(200)
    end
  end
end
