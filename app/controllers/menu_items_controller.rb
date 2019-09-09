class MenuItemsController < ApplicationController
  before_action :require_login

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu_item = @restaurant.menu_items.build
    @tags = Tag.all
  end

  def edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu_item = @restaurant.menu_items.find(params[:id])
    @tags = Tag.all
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu_item = @restaurant.menu_items.build(menu_item_params)

    if @menu_item.save
      redirect_to @restaurant
    else
      render 'new'
    end
  end

  def update
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu_item = @restaurant.menu_items.find(params[:id])

    if @menu_item.update(menu_item_params)
      redirect_to @restaurant
    else
      render 'edit'
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu_item = @restaurant.menu_items.find(params[:id])
    @menu_item.destroy

    flash[:notice] = t('flash.destroy', resource: MenuItem.model_name.human)
    redirect_to @restaurant
  end

private

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :tag_id)
  end

end
