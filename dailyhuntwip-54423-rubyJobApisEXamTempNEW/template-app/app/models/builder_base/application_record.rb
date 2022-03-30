module BuilderBase
  class ApplicationRecord < ::ApplicationRecord
    extend AbilityFilter

    self.abstract_class = true
    self.store_full_sti_class = false
  end
end
