class PaidLunchesController < ApplicationController
  before_action :require_login

  def new
  end

  def search
    @restaurants = PaidLunchQuery.new(params).call

    render 'search'
  end
end
