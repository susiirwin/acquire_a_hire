require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zipcode) }
  end

  context 'average ratings' do
    it 'calculates the average rating of a user' do
      user = create(:user, first_name: "Sarah", role: 0)
      user2 = create(:professional_user)
      user3 = create(:user, first_name: "Susi", role: 0)
      job = create(:job, requester_id: user.id, professional_id: user2.id)

      user_ratings = [
            Review.create(rating: 2,
                          review: 'test review 1',
                          requester_id: user3.id,
                          professional_id: user2.id,
                          reviewee_role: 'requester'),
            Review.create(rating: 3,
                          review: 'test review 2',
                          requester_id: user.id,
                          professional_id: user2.id,
                          reviewee_role: 'requester'),
            Review.create(rating: 4,
                          review: 'test review 3',
                          requester_id: user.id,
                          professional_id: user2.id,
                          reviewee_role: 'requester'),
            Review.create(rating: 4,
                          review: 'test review 4',
                          requester_id: user.id,
                          professional_id: user2.id,
                          reviewee_role: 'requester')
                        ]

      expect(user.average_rating).to eq(3.67)
    end
  end
end
