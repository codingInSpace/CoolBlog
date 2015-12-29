class UsersController < ApplicationController
  before_action :get_user, only: [:edit, :update, :destroy, :show]
  before_filter :accessible_roles, :only => [:new, :edit, :show, :update, :create]
  before_action :authenticate_user!
  load_and_authorize_resource :only => [:show,:new,:destroy,:edit,:update]

  def index
    @users = User.all.order(id: :asc)
  end

  def show
  end

  def new
    @user = User.new
  end

	def edit
	end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Successfully created User."
    else
      render :action => 'new'
    end
  end

  def update
		update_params = user_params

    the_roles = []
    the_roles = Role.find(user_params[:role_ids]) if !user_params[:role_ids].nil?

    if @user.update_attributes(update_params) and @user.roles.replace(the_roles)
      flash[:notice] = "Successfully updated user " + @user.name + "."
      redirect_to admin_users_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
    end
  end

  private
    def user_params
      params.require(:user).permit(:id, :name, :email, :password, {:role_ids => []})
    end

    # Get the sought user once
    def get_user
      @user = User.find(params[:id])
    end

    # Get roles accessible by the current user
    def accessible_roles
      @accessible_roles = Role.accessible_by(current_ability,:read)
    end
end
