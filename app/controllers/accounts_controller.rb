class AccountsController < ApplicationController
  before_filter :top_level_domain_required, :only => [:new, :create]
  ssl_required :new, :create
  
  layout "dialog"
  
  def new
    delete_old_cookies
    @account = Account.new
    @user = User.new
  end
  
  def welcome
    @token = params[:token]
    if @user = User.authenticate_by_perishable_token(@token)
      self.current_user = @user
      remember_me!
    else
      flash[:error] = "Bad authentication token"
      redirect_to signup_path
    end
  end
  
  def create
    logout_keeping_session!
    @account = Account.new(params[:account])
    @user = @account.users.build(params[:user])
    @user.admin = true
    
    User.transaction do
      @account.save!
      @user.activate!
      
      MonitorMailer.deliver_signup(@account, @user)
      
      @user.create_perishable_token!
      redirect_to welcome_url(:host => account_host(@account), :token => @user.perishable_token)
    end
    
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
end
