class RandomLunchesController < ApplicationController
  before_action :require_login

  def new
  end

  def search
    @restaurants = RandomLunchQuery.new(params).call

    render 'search'
  end
end
