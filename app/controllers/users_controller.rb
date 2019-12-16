class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @orders = @user.orders.includes(:line_items, {line_items: [:product]})
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
    else
      render 'edit'
    end
  end

  def add_product_to_cart
    return error_message unless current_user

    cart = current_user.cart_items.find_or_create_by(
      product_id: products_params
    )

    respond_to do |format|
      format.json { render json: { cart_id: cart.try(:id) }, status: 200 }
    end
  end

  def cart_items
    return error_message unless current_user

    @cart_items = current_user.cart_items

    html = render_to_string('shared/_cart_items', formats: :html, layout: false)

    respond_to do |format|
      format.json { render json: { html: html }, status: 200 }
    end
  end


  private

  def error_message
    respond_to do |format|
      format.json { render json: { error: 'please login before add product to cart' }, status: 200 }
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmation)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def products_params
    params.require(:product_id)
  end
end