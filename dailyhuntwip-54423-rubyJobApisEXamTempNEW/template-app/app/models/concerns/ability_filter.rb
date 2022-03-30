module AbilityFilter
  def by_current_user(user)
    ability = Ability.new(user)
    self.accessible_by(ability)
  end
end
