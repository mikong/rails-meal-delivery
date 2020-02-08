# frozen_string_literal: true

class PaidLunchQuery
  def initialize(params = {})
    @budget = params[:budget] # TODO: validate Money
    @tag_quantities = params[:tag_quantities]
  end

  def call
    restaurants = RandomLunchQuery.new({ tag_ids: @tag_quantities.keys }).call

    restaurants.select do |restaurant|
      sum = Money.new(0)
      @tag_quantities.each do |tid, quantity|
        cheapest = restaurant.cheapest_menu_item_by(tid)

        # next  if cheapest.nil?
        sum += cheapest.price * quantity
      end

      @budget >= sum
    end
  end
end
