class PaidLunchesController < ApplicationController
  before_action :require_login

  def new
  end

  def search
    @restaurants = PaidLunchQuery.new(search_params).call

    render 'search'
  end

private

  def search_params
    params.permit(:budget, tag_quantities: {})
  end

end
