require_dependency "support_ticketx/application_controller"

module SupportTicketx
  class IssuesController < ApplicationController

    def index
      @title = t('Existing Issues')
      @issues = SupportTicketx::Issue.find(:all)
      #@issues = @issues.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('issue_index_view', 'support_ticketx')
    end

    def new
      @title = t('New Issue')
      @issue = SupportTicketx::Issue.new(attributes=eval(Authentify::AuthentifyUtility.find_config_const('support_ticket_new_attrs', 'support_ticketx')))
      @erb_code = find_config_const('issue_new_view', 'support_ticketx')
    end

    def create
      update_params
      @issue = SupportTicketx::Issue.new(attributes = params[:issue], persisted = false)
      if @issue.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('issue_new_view', 'support_ticketx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Issue')
      @issue = SupportTicketx::Issue.find(params[:id])
      @erb_code = find_config_const('issue_edit_view', 'support_ticketx')
      @erb_code_custom_fields = find_config_const('issue_custom_fields_view', 'support_ticketx')
    end

    def update
      update_params
      @issue = SupportTicketx::Issue.new(attributes = params[:issue], persisted = true)
      if @issue.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('issue_edit_view', 'support_ticketx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end

    def show
      @title = t('Issue Details')
      @issue = SupportTicketx::Issue.find(params[:id])
      @erb_code = find_config_const('issue_show_view', 'support_ticketx')
    end

    def update_params
      params[:issue]['custom_fields'] = eval(Authentify::AuthentifyUtility.find_config_const('issue_custom_fields', 'support_ticketx'))
      params[:issue]['project_id'] =Authentify::AuthentifyUtility.find_config_const('project_id', 'support_ticketx')
      priorities = Authentify::AuthentifyUtility.find_config_const('priorities_list', engine='support_ticketx').split(',')
      index = priorities.collect{|x| x.split(':')[1]}.index(params[:issue]['priority_name'] || params[:issue]['priority'])
      params[:issue]['priority_id'] = priorities[index].split(':')[0].to_i  if index
    end

  end
end
