class PaidLunchQuery
  def initialize(params = {})
    @budget = Money.from_amount(params[:budget].to_f)
    @tag_quantities = params[:tag_quantities].to_hash.reduce({}) do |h, (k, v)|
      value = v.to_i
      h[k] = value  if value > 0
      h
    end
  end

  def call
    restaurants = RandomLunchQuery.new({ tag_ids: @tag_quantities.keys }).call

    restaurants.select do |restaurant|
      sum = Money.new(0)
      @tag_quantities.each do |tid, quantity|
        cheapest = restaurant.menu_items
          .where(tag_id: tid)
          .order(:price_cents)
          .first
        sum += cheapest.price * quantity
      end

      @budget >= sum
    end
  end
end
