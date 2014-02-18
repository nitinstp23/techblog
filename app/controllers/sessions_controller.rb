class SessionsController < ApplicationController
  before_action :redirect_if_signed_in, only: [:new, :create]
  skip_before_action :authenticate, only: [:new, :create]

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)

    if @session.valid?
      session[:user_id] = @session.user_id
      redirect_to @session.redirect_url, notice: 'Signed in Successfully'
    else
      render :new
    end
  end

  def signout
    session[:user_id] = nil
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end

  def redirect_if_signed_in
    redirect_to root_url if signed_in?
  end
end
