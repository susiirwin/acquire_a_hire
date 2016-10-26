require 'rails_helper'

describe 'Show Reviews'  do
  it 'show all reviews for the requester' do
      user = create(:requester_user, first_name: "Sarah")
      user2 = create(:professional_user)
      review = Review.create(rating: 2,
                             review: 'test review 1',
                             requester_id: user.id,
                             professional_id: user2.id,
                             reviewee_role: 'requester')

      visit user_path(user)

    within('div.review') do
      expect(page).to have_content("Review for #{user.full_name}")
      expect(page).to have_content("Written by #{user2.business_name}")
      expect(page).to have_content(review.review)
      expect(page).to have_content(review.rating)
    end
  end
end
