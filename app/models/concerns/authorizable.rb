module Authorizable
  extend ActiveSupport::Concern

  included do
    # Empty for now
  end

  def owned_by?(user)
    user_id == user.id
  end
end