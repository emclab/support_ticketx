require 'spec_helper'

module SupportTicketx
  describe IssuesController do
    before(:each) do
      controller.should_receive(:require_signin)
    end

    before(:each) do
      SupportTicketx::Issue.headers.clear
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])

      FactoryGirl.create(:engine_config, :engine_name => 'support_ticketx', :engine_version => nil, :argument_name => 'support_ticket_url', :argument_value => 'http://localhost:3000')
      FactoryGirl.create(:engine_config, :engine_name => 'support_ticketx', :engine_version => nil, :argument_name => 'support_ticket_new_attrs', :argument_value => "{:project_id => 1, :subject => nil, :description => nil, :priority => nil, :created_on => nil, :custom_fields => Array.new([ {:name => 'app_name', :value => nil} , {:name => 'comments', :value => nil}, {:name => 'contact_name', :value => nil}, {:name => 'contact_email', :value => nil}])}")
      FactoryGirl.create(:engine_config, :engine_name => 'support_ticketx', :engine_version => nil, :argument_name => 'support_ticket_access_key', :argument_value => 'ce593b1f853c1e3f913621576869c7163ce386f6')
      FactoryGirl.create(:engine_config, :engine_name => 'support_ticketx', :engine_version => nil, :argument_name => 'project_id', :argument_value => '1')
      FactoryGirl.create(:engine_config, :engine_name => 'support_ticketx', :engine_version => nil, :argument_name => 'priorities_list', :argument_value => '3:Major,4:Minor,5:Critial')
      FactoryGirl.create(:engine_config, :engine_name => 'support_ticketx', :engine_version => nil, :argument_name => 'issue_custom_fields', :argument_value =>
          "Array.new([ {:id => 1, :name => 'app_name', :value => Rails.application.class.parent_name} ,
                      {:id => 2, :name => 'comments', :value => params[:issue]['comments'] },
                      {:id => 3, :name => 'contact_name', :value => params[:issue]['contact_name'] },
                      {:id => 4, :name => 'contact_email', :value => params[:issue]['contact_email'] }])")

      SupportTicketx::Issue.site = 'http://localhost:3000' #Authentify::AuthentifyUtility.find_config_const('support_ticket_url', 'support_ticketx')
      SupportTicketx::Issue.user = nil #'machouicha'
      SupportTicketx::Issue.password = nil
      @mockOneIssue = '<?xml version="1.0" encoding="UTF-8"?><issues total_count="1" offset="0" limit="25" type="array"><issue><id>2</id><project id="1" name="Project1"/><tracker id="1" name="tracker1"/><status id="1" name="open"/><priority id="3" name="Major"/><author id="1" name="Redmine Admin"/><assigned_to id="1" name="Redmine Admin"/><subject>Issue2</subject><description>Description of issue2</description><start_date>2015-02-15</start_date><due_date/><done_ratio>0</done_ratio><is_private>false</is_private><estimated_hours/><custom_fields type="array"><custom_field id="1" name="app_name"><value>byop</value></custom_field><custom_field id="1" name="comments"><value>new comment</value></custom_field><custom_field id="1" name="contact_name"><value>John</value></custom_field><custom_field id="1" name="contact_email"><value>john@abc.com</value></custom_field></custom_fields><created_on>2015-02-16 04:10:09 UTC</created_on><updated_on>2015-02-16 04:10:09 UTC</updated_on><closed_on/></issue></issues>'
      @mockOneNewIssue = '<?xml version="1.0" encoding="UTF-8"?><issues total_count="1" offset="0" limit="25" type="array"><issue><id></id><project id="1" name="Project1"/><tracker id="1" name="tracker1"/><status id="1" name="open"/><priority id="3" name="Major"/><author id="1" name="Redmine Admin"/><assigned_to id="" name=""/><subject></subject><description></description><start_date></start_date><due_date/><done_ratio>0</done_ratio><is_private>false</is_private><estimated_hours/><custom_fields type="array"><custom_field id="" name=""><value></value></custom_field><custom_field id="" name=""><value></value></custom_field><custom_field id="" name=""><value></value></custom_field><custom_field id="" name=""><value></value></custom_field></custom_fields><created_on></created_on><updated_on></updated_on><closed_on/></issue></issues>'
      @mockIssues = '<?xml version="1.0" encoding="UTF-8"?><issues total_count="2" offset="0" limit="25" type="array"><issue><id>2</id><project id="1" name="Project1"/><tracker id="1" name="tracker1"/><status id="1" name="open"/><priority id="3" name="Major"/><author id="1" name="Redmine Admin"/><assigned_to id="1" name="Redmine Admin"/><subject>Issue2</subject><description>Description of issue2</description><start_date>2015-02-15</start_date><due_date/><done_ratio>0</done_ratio><is_private>false</is_private><estimated_hours/><custom_fields type="array"><custom_field id="1" name="app_name"><value>byop</value></custom_field><custom_field id="1" name="comments"><value>new comment</value></custom_field><custom_field id="1" name="contact_name"><value>John</value></custom_field><custom_field id="1" name="contact_email"><value>john@abc.com</value></custom_field></custom_fields><created_on>2015-02-16 04:10:09 UTC</created_on><updated_on>2015-02-16 04:10:09 UTC</updated_on><closed_on/></issue><issue><id>5</id><project id="1" name="Project1"/><tracker id="1" name="tracker1"/><status id="1" name="open"/><priority id="3" name="Major"/><author id="6" name="Amine Chouicha"/><assigned_to id="1" name="Redmine Admin"/><subject>REST API</subject><description>Description of issue5</description><start_date>2015-02-15</start_date><due_date/><done_ratio>0</done_ratio><is_private>false</is_private><estimated_hours/><custom_fields type="array"><custom_field id="1" name="app_name"><value>byop</value></custom_field><custom_field id="1" name="comments"><value>new comment</value></custom_field><custom_field id="1" name="contact_name"><value>John</value></custom_field><custom_field id="1" name="contact_email"><value>john@abc.com</value></custom_field></custom_fields><created_on>2015-02-16 04:10:09 UTC</created_on><updated_on>2015-02-16 04:10:09 UTC</updated_on><closed_on/></issue></issues>'
      @mockOneIssue = '<?xml version="1.0" encoding="UTF-8"?><issue><created-on>02/15/2015</created-on><custom-fields type="array"><custom-field><id>1</id><name>app_name</name><value>dummy</value></custom-field><custom-field><id>2</id><name>comments</name><value>test comment</value></custom-field><custom-field><id>3</id><name>contact_name</name><value>amine</value></custom-field><custom-field><id>4</id><name>contact_email</name><value>amine@abc.com</value></custom-field></custom-fields><description>Test Description</description><last-updated-by-id type="integer">1</last-updated-by-id><priority><name>Major</name></priority><project-id>1</project-id><subject>test Subject</subject></issue>'

      ActiveResource::HttpMock.respond_to do |mock|
          mock.get    "/issues.xml", {}, @mockIssues
          mock.get    "/issues/new.xml", {}, @mockOneNewIssue
          #mock.post    "/issues.xml", {}, @@mockOneIssue
          mock.post    "/issues.xml", {}, @mockOneIssue
          #mock.post   "/issue.xml",   {}, @mockOneIssue, 201, "Location" => "/issue/1.xml"
          mock.get    "/issues/1.xml", {}, @mockOneIssue
          mock.put    "/issues/1.xml", {}, @mockOneIssue
          mock.delete "/issue/1.xml", {}, nil, 200
      end
    end

    render_views

    describe "GET 'index'" do
      it "returns support_tickets" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'support_ticketx_issues', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "SupportTicketx::Issue.find(:all)")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'index', {:use_route => :support_ticketx}
        issue1 = Issue.new(attributes = {:id => '2', :project => {:id =>'1', :name => 'Project1'}, :tracker => {:id =>'1', :name => 'tracker1'}, :status => {:id => '1', :name => 'open'}, :priority => {:id => '3',  :name => "Major"}, :author => {:id => "1", :name => "Redmine Admin"}, :assigned_to => {:id =>"1", :name => "Redmine Admin"}, :subject =>'Issue2',:description => 'Description of issue2', :start_date => '2015-02-15'   ,:due_date => nil, :done_ratio => '0', :is_private => 'false', :estimated_hours => nil ,:custom_fields  => Array.new([ {:custom_field => {:id =>"1", :name => "app_name", :value => 'byop'}},{:custom_field => {:id =>"1", :name => "comments", :value => 'new comment'}},{:custom_field => {:id =>"1", :name => "contact_name", :value => 'John'}},{:custom_field => {:id =>"1", :name => "contact_email", :value => 'john@abc.com'}}]), :created_on => '2015-02-16 04:10:09 UTC', :updated_on => '2015-02-16 04:10:09 UTC', :closed_on => nil}, persisted =true)
        issue2 =  Issue.new(attributes = {:id => '5', :project => {:id =>'1', :name => 'Project1'}, :tracker => {:id =>'1', :name => 'tracker1'}, :status => {:id => '1', :name => 'open'}, :priority => {:id => '3',  :name => "Major"}, :author => {:id => "6", :name => "Amine Chouicha"}, :assigned_to => {:id =>"1", :name => "Redmine Admin"},:subject =>'REST API',:description => 'Description of issue5', :start_date => '2015-02-15',:due_date => nil, :done_ratio => '0', :is_private => 'false', :estimated_hours => nil ,:custom_fields  => Array.new([ {:custom_field => {:id =>"1", :name => "app_name", :value => 'byop'}},{:custom_field => {:id =>"1", :name => "comments", :value => 'new comment'}},{:custom_field => {:id =>"1", :name => "contact_name", :value => 'John'}},{:custom_field => {:id =>"1", :name => "contact_email", :value => 'john@abc.com'}}]), :created_on => '2015-02-16 04:10:09 UTC', :updated_on => '2015-02-16 04:10:09 UTC', :closed_on => nil}, persisted =true)
        assigns[:issues].should =~ [issue1, issue2]
      end

    end

    describe "GET 'new'" do
      it "returns bring up new page" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'support_ticketx_issues', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :support_ticketx}
        response.should be_success
      end
    end

    describe "GET 'create'" do
      it "returns bring up new page" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'support_ticketx_issues', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        @attributes = {:project_id => '1', :subject => 'test Subject', :description => 'Test Description', :priority => 'Major', :created_on => '02/15/2015', :custom_fields => Array.new([ {:custom_field => {:id => 1, :name => 'app_name', :value => 'dummy'} }, {:custom_field => {:id => 2, :name => 'comments', :value => 'test comment'}}, {:custom_field => {:id => 3, :name => 'contact_name', :value => 'amine'} }, {:custom_field => {:id => 4, :name => 'contact_email', :value => 'amine@abc.com'}}])}
        get 'create', {:use_route => :support_ticketx, :issue => @attributes}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end

      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'support_ticketx_issues', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        @attributes = {:project_id => '1', :subject => nil, :description => nil, :priority => nil, :created_on => '02/15/2015', :custom_fields => Array.new([ {:custom_field => {:id => 1, :name => 'app_name', :value => 'dummy'} }, {:custom_field => {:id => 2, :name => 'comments', :value => 'test comment'}}, {:custom_field => {:id => 3, :name => 'contact_name', :value => 'amine'} }, {:custom_field => {:id => 4, :name => 'contact_email', :value => 'amine@abc.com'}}])}
        get 'create', {:use_route => :support_ticketx, :issue => @attributes }
        response.should render_template('new')
      end

    end

    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'support_ticketx_issues', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'edit', {:use_route => :support_ticketx, :id => 1}
        response.should be_success
      end

    end

    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'support_ticketx_issues', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        @attributes = {:id => 1, :project_id => '1', :subject => 'test Subject', :description => 'Test Description', :priority => 'Major', :created_on => '02/15/2015', :custom_fields => Array.new([ {:custom_field => {:id => 1, :name => 'app_name', :value => 'dummy'} }, {:custom_field => {:id => 2, :name => 'comments', :value => 'test comment'}}, {:custom_field => {:id => 3, :name => 'contact_name', :value => 'amine'} }, {:custom_field => {:id => 4, :name => 'contact_email', :value => 'amine@abc.com'}}])}
        get 'update', {:use_route => :support_ticketx, :issue => @attributes}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end

      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'support_ticketx_issues', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        @attributes = {:id => 1, :project_id => '1', :subject => nil, :description => 'Test Description', :priority => {:name => 'Major'}, :created_on => '02/15/2015', :custom_fields => Array.new([ {:custom_field => {:id => 1, :name => 'app_name', :value => 'dummy'} }, {:custom_field => {:id => 2, :name => 'comments', :value => 'test comment'}}, {:custom_field => {:id => 3, :name => 'contact_name', :value => 'amine'} }, {:custom_field => {:id => 4, :name => 'contact_email', :value => 'amine@abc.com'}}])}
        get 'update', {:use_route => :support_ticketx, :issue => @attributes}
        response.should render_template('edit')
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'support_ticketx_issues', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        issue1 = Issue.new(attributes = {:id => '1', :project => {:id =>'1', :name => 'Project1'}, :tracker => {:id =>'1', :name => 'tracker1'}, :status => {:id => '1', :name => 'open'}, :priority => {:id => '3',  :name => "Major"}, :author => {:id => "1", :name => "Redmine Admin"}, :assigned_to => {:id =>"1", :name => "Redmine Admin"}, :subject =>'Issue2',:description => 'Description of issue2', :start_date => '2015-02-15'   ,:due_date => nil, :done_ratio => '0', :is_private => 'false', :estimated_hours => nil ,:custom_fields  => Array.new([ {:custom_field => {:id =>"1", :name => "app_name", :value => 'byop'}},{:custom_field => {:id =>"1", :name => "comments", :value => 'new comment'}},{:custom_field => {:id =>"1", :name => "contact_name", :value => 'John'}},{:custom_field => {:id =>"1", :name => "contact_email", :value => 'john@abc.com'}}]), :created_on => '2015-02-16 04:10:09 UTC', :updated_on => '2015-02-16 04:10:09 UTC', :closed_on => nil}, persisted =true)
        get 'show', {:use_route => :support_ticketx, :id => issue1.id}
        response.should be_success
      end
    end

  end
end
