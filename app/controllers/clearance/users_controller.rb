class Clearance::UsersController < ApplicationController
	before_filter :redirect_signed_in_users, only: [:create, :new]
  skip_before_filter :require_login, only: [:create, :new]
  skip_before_filter :authorize, only: [:create, :new]

  def new
    @user = user_from_params
    render template: "users/new"
  end

  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  private

  def avoid_sign_in
    warn "[DEPRECATION] Clearance's `avoid_sign_in` before_filter is " +
      "deprecated. Use `redirect_signed_in_users` instead. " +
      "Be sure to update any instances of `skip_before_filter :avoid_sign_in`" +
      " or `skip_before_action :avoid_sign_in` as well"
    redirect_signed_in_users
  end

  def redirect_signed_in_users
    if signed_in?
      redirect_to Clearance.configuration.redirect_url
    end
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

		def user_from_params
			first_name = user_params.delete(:first_name)
			last_name = user_params.delete(:last_name)
			phone = user_params.delete(:phone)
			birthday = user_params.delete(:birthday)
			about = user_params.delete(:about)
			picture = user_params.delete(:picture)
		    email = user_params.delete(:email)
		    password = user_params.delete(:password)


		    Clearance.configuration.user_model.new(user_params).tap do |user|
		      user.first_name = first_name
		      user.last_name = last_name
		      user.phone = phone
		      user.birthday = birthday
		      user.about = about
		      user.picture = picture		      
		      user.email = email
		      user.password = password
		    end
	  	end

	  	  def user_params
		    params[:user] || Hash.new
		  end

		def permit_params
		  params.require(:user).permit(:first_name, :last_name, :phone, :birthday, :about, :picture, :email, :password)
		end
end