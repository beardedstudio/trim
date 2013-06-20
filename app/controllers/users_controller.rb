class UsersController < InheritedController

  before_filter :strip_password_params_if_not_set, :only => :update
  before_filter :add_to_editables
  
  def update

    if @user.id == current_user.id
      if @user.update_attributes(params[:user])

        sign_in(:user, @user, :bypass => true)

        if params[:user][:password].blank? 
          flash[:notice] = 'Your user information has been updated successfully.'
        else
          flash[:notice] = 'Your user information and password have been updated successfully.'
        end

        redirect_to user_path(@user.id)

      else
        flash[:alert] = 'There was a problem updating your account.'
        render :template => 'users/edit'
      end

    else
      update!( :notice => 'The User information has been updated successfully.' )
    end
  end

  def strip_password_params_if_not_set
    if params[:user] && params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

end
