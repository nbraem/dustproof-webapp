class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  respond_to :html
  add_breadcrumb :index, :users_path

  def index
    @q = User.search(params[:q])
    @q.sorts = "last_name asc" if @q.sorts.empty?
    @users = @q.result(distinct: true).page(params[:page])
    respond_with(@users)
  end

  def show
    add_breadcrumb @user.full_name
    respond_with(@user)
  end

  def new
    add_breadcrumb :new
    @user = User.new
    respond_with(@user)
  end

  def edit
    add_breadcrumb @user.full_name, @user
    add_breadcrumb :edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      add_breadcrumb :new
      render :new
    end
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    if user_tries_to_update_own_admin_status
      redirect_to :back, alert: t("flash.users.cannot_change_own_admin_status")
    else
      if @user.update(user_params)
        redirect_to @user
      else
        add_breadcrumb @user.full_name, @user
        add_breadcrumb :edit
        render :edit
      end
    end
  end

  def destroy
    if user_tries_to_delete_own_account
      redirect_to :back, alert: t("flash.users.cannot_delete_own_account")
    else
      @user.destroy
      respond_with(@user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.
      require(:user).
      permit(:first_name,
             :last_name,
             :email,
             :password,
             :admin)
  end

  def user_tries_to_delete_own_account
    @user == current_user
  end

  def user_tries_to_update_own_admin_status
    params[:user][:admin].present? && @user == current_user
  end
end
