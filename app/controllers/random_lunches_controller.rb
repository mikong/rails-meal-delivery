# frozen_string_literal: true

class RandomLunchesController < ApplicationController
  before_action :require_login

  def new
    @tags = Tag.all
  end

  def search
    @restaurants = RandomLunchQuery.new(params).call

    render 'search'
  end

  def employee
    @employees = Employee.all
    @tags = Tag.all
  end

  def employee_search
    @restaurants = RandomLunchQuery.new(params).call

    render 'employee_search'
  end
end
