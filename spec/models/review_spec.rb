require 'rails_helper'

RSpec.describe Review, type: :model do
  it { is_expected.to belong_to :professional }
  it { is_expected.to belong_to :requester }
end
