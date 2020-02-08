# frozen_string_literal: true

class RandomLunchQuery
  def initialize(params = {})
    @tag_ids = params[:tag_ids].delete_if {|e| e.empty?}.uniq
  end

  def call
    base_query = Restaurant.includes(:taggings).references(:taggings)

    @tag_ids.reduce(Restaurant.all) do |scope, tid|
      scope.where(id: base_query.where(taggings: { tag_id: tid }).select(:id))
    end
  end
end
