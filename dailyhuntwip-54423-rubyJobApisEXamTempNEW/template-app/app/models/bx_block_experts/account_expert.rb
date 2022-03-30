# == Schema Information
#
# Table name: account_experts
#
#  id               :bigint           not null, primary key
#  follow           :boolean
#  mode             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :integer
#  career_expert_id :integer
#
class BxBlockExperts::AccountExpert < ApplicationRecord
  self.table_name = :account_experts
  belongs_to :account, class_name:"AccountBlock::Account"
  belongs_to :career_expert, class_name:"BxBlockExperts::CareerExpert"
  enum mode: ['Book', 'Follow']
end
