require 'rails_helper'

RSpec.describe BxBlockCategories::BuildCategories, type: :services do

  let(:build_category_input){
    {
      "K12"=> ["Pre Value (kg)", "Primary (1 to 5)"], 
      "Higher Education"=>["Accounting & Commerce", "Animation"]
    }
  }

  context 'should call when we intialize the database' do
    
    it 'should call with same category and sub_category' do
      build_category_output = BxBlockCategories::BuildCategories.call(build_category_input)
      expect(build_category_output).to eq (build_category_input)
    end
  end
end
