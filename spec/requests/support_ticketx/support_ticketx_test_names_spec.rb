require 'spec_helper'

RSpec.describe "TestNames", :type => :request do
  describe "GET /support_ticketx_test_names" do
    it "works! (now write some real specs)" do
      get support_ticketx_test_names_path
      expect(response).to have_http_status(200)
    end
  end
end
