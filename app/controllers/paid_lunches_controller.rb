# frozen_string_literal: true

class PaidLunchesController < ApplicationController
  before_action :require_login

  def new
    @tags = Tag.all
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

  def employee
    @employees = Employee.all
    @tags = Tag.all
  end

  def employee_search
    @budget = budget
    @tag_quantities = tag_ids_to_quantities

    paid_lunch_query = PaidLunchQuery.new(
      budget: @budget,
      tag_quantities: @tag_quantities
    )
    @restaurants = paid_lunch_query.call

    render 'employee_search'
  end

  private

  def search_params
    params.permit(:budget, tag_ids: [], tag_quantities: {})
  end

  def budget
    Money.from_amount(search_params[:budget].to_f)
  end

  def tag_quantities
    search_params[:tag_quantities].to_hash.reduce({}) do |h, (k, v)|
      value = v.to_i
      h[k] = value if value > 0
      h
    end
  end

  def tag_ids_to_quantities
    search_params[:tag_ids].reduce({}) do |h, tid|
      if tid.present?
        h.member?(tid) ? h[tid] += 1 : h[tid] = 1
      end

      h
    end
  end
end
