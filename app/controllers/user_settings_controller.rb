class UserSettingsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes_without_password(params[:user])
      # Sign in the user by passing validation in case his password changed
      redirect_to root_path
    else
      render "edit"
    end
  end
end
