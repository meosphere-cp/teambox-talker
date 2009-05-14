class UsersController < ApplicationController
  def new
    @user = current_account.users.build
  end
 
  def create
    logout_keeping_session!
    @user = current_account.users.build(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      render :action => 'new'
    end
  end
end
