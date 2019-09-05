class RandomLunchQuery
  def initialize(params = {})
    @tag_ids = params[:tag_ids].delete_if {|e| e.empty?}
  end

  def call
    Restaurant.includes(:taggings).where(taggings: { tag_id: @tag_ids}).references(:taggings)
  end
end
