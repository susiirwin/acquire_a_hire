require 'rails_helper'

describe "Professional leaves Review" do
  context "for requester" do
    it "shows review form and submitted review" do
      pro = create(:professional_user)
      job = create(:job, title: "Paint the Roof",professional: pro,
                    requester: create(:requester_user))
      # when I visit a job assigned to me
      visit "/professionals/jobs/#{job.id}"
      expect(page).to have_content("Paint the Roof")
      # and I click a "review requester" button
      click_on "Review Requester"
      # i should be on a page for the requester/review/create
      expect(current_path).to eq(new_requesters_review_path)
      # and I put in my review
      fill_in 'requester_notes', with: 'This is my review of the requester'
      # and I select a rating
      choose('four_stars')
      # and I click submit
      click_on "Submit"
      # and I see the Review Show Page
      expect(current_path).to eq (requesters_review)
      # I expect the review text and the rating
      expect(page).to have_content("This is my review of the requester")
    end
  end
end
