class SessionsController < ApplicationController
  def new
    @user = User.new
    
  end

  def create
    @user = User.find_by_cred(params[:user][:username], params[:user][:password])
    if @user
      login(@user)
      redirect_to subs_url
    else
      flash.now[:errors] = ['No Go']
      render :new
    end
  end

  def destroy
    logout
  end
end
