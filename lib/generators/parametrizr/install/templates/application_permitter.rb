class ApplicationPermitter
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def all_actions
    params
  end
end
