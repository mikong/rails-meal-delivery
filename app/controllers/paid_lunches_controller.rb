class PaidLunchesController < ApplicationController
  before_action :require_login

  def new
  end

  def search
    @budget = budget
    @tag_quantities = tag_quantities

    paid_lunch_query = PaidLunchQuery.new(
      budget: @budget,
      tag_quantities: @tag_quantities
    )
    @restaurants = paid_lunch_query.call

    render 'search'
  end

private

  def search_params
    params.permit(:budget, tag_quantities: {})
  end

  def budget
    Money.from_amount(search_params[:budget].to_f)
  end

  def tag_quantities
    search_params[:tag_quantities].to_hash.reduce({}) do |h, (k, v)|
      value = v.to_i
      h[k] = value  if value > 0
      h
    end
  end

end
