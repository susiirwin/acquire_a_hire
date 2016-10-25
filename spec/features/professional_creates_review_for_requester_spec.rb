require 'rails_helper'

describe "Professional leaves Review" do
  context "for requester" do
    it "shows review form and submitted review" do
      pro = create(:professional_user)
      ApplicationController.any_instance.stubs(:current_user).returns(pro)
      job = create(:job, title: "Paint the Roof",professional: pro,
                    requester: create(:requester_user))

      visit "/jobs/#{job.id}"

      expect(page).to have_content("Paint the Roof")

      click_on "Review Requester"

      expect(current_path).to eq(new_requesters_review_path)

      fill_in 'review_review', with: 'This is my review of the requester'
      choose('review_rating_four_stars')

      click_on "Create Review"

      review = Review.last
      expect(current_path).to eq (requesters_review_path(review))

      expect(page).to have_content("This is my review of the requester")
      expect(page).to have_content("four_stars")
    end
  end
end
