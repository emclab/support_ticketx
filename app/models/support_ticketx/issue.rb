require 'rubygems'
require 'active_resource'

module SupportTicketx

  # Issue model on the client side
  class Issue < ActiveResource::Base
    self.site = SITE
    headers["X-Redmine-API-Key"] = ACCESS_KEY
    self.element_name = 'issue'
    self.format = :xml
    include_root_in_json = true
    validate :local_validation

    def app_name
      custom_fields[0].value
    end

    def app_name=(name)
      custom_fields[0].value = name
    end

    def comments
      custom_fields[1].value
    end

    def comments=(comments)
      custom_fields[1].value = comments
    end

    def contact_name
      custom_fields[2].value
    end

    def contact_name=(name)
      custom_fields[2].value = name
    end

    def contact_email
      custom_fields[3].value
    end

    def contact_email=(name)
      custom_fields[3].value = name
    end

    def author
      author.name
    end

    def author=(name)
      author.name = name
    end

    def status_name
      status.name if status
    end

    def status_name=(name)
      status.name = name
    end

    def priority_name
      priority.name if self.respond_to?('priority')
    end

    def priority_name=(name)
      priority.name = name

    end

    def assigned_to_name
      assigned_to.name if self.respond_to?('assigned_to')
    end


    def assigned_to_name=(assigned_to)
      assigned_to.name = assigned_to
    end

    protected
    def local_validation
      errors.add("subject", "can't be empty") if attributes['subject'].blank?
      errors.add("description", "can't be empty") if attributes['description'].blank?
      #errors.add("priority", "can't be empty") if attributes['priority'].blank?
    end
  end
end


=begin

# Retrieving issues
SupportTicketx::Issue.site = 'http://localhost:3000'
SupportTicketx::Issue.headers["X-Redmine-API-Key"] = "ce593b1f853c1e3f913621576869c7163ce386f6"


issues = SupportTicketx::Issue.find(:all)
puts issues.first.subject
#issue = SupportTicketx::Issue.new() #(attributes={:project_id =>"1"})
#puts issue
# issue.save
# Retrieving an issue
#issue = Issue.find(1)
#puts issue.description
#puts issue.author.name

# Creating an issue
issue = SupportTicketx::Issue.new(
    :subject => 'REST API',
    :assigned_to_id => "1",
    :project_id => "1" ,
    :description => 'Some description',
    :priority_id => 4,
    :custom_fields => [{:id => 1, :name => 'app_name', :value => 'testDummy'}, {:id => 3, :name => 'contact_name', :value => 'testname'}, {:id => 4, :name => 'contact_email', :value => 'testname@abc.com'} ]
    #:custom_fields => [{:name => 'app_name', :value => 'testDummy'}, {:name => 'contact_name', :value => 'testname'}, {:name => 'contact_email', :value => 'testname@abc.com'} ]
)


issue1 = SupportTicketx::Issue.new(
    :subject => 'REST API',
    :assigned_to_name => "RedmineAdmin",
    :project_id => "1" ,
    :description => 'Some description1',
    :priority_id => 4
#:custom_fields => [{:id => 1, :name => 'app_name', :value => 'testDummy'}, {:id => 3, :name => 'contact_name', :value => 'testname'}, {:id => 4, :name => 'contact_email', :value => 'testname@abc.com'} ]
)


#issue.custom_field_values = {'1' => 'testDummy', '2' => 'test_name', '3' => 'test@abc.com'}
#issue.custom_fields = nil
if issue.save
  puts issue.id
else
  puts issue.errors.full_messages
end



# Updating an issue
issue = Issue.find(1)
issue.subject = 'REST API'
issue.save

# Deleting an issue
issue = Issue.find(1)
issue.destroy
=end