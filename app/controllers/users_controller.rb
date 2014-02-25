class UsersController < ApplicationController

  before_action :authenticate

  def edit
    @user = User.first
  end

  def update
    @user = User.find_by(id: params[:id])

    if @user.update(update_params)
      redirect_to root_url, notice: 'Password Changed Successfully'
    else
      render :edit
    end
  end

  private

  def update_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
