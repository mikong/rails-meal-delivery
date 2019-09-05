class RandomLunchQuery
  def initialize(params = {})
    @params = params
  end

  def call
    Restaurant.all
  end
end
