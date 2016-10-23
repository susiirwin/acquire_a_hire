require 'rails_helper'

describe 'user visits job show page' do
  context 'professional visits page and can send message' do
    it 'sees job title, skill, price range and description' do
      pro = create(:user)
      pro.update(role: 'professional')
      ApplicationController.any_instance.stubs(:current_user).returns(pro)
      job = create(:job)
      visit job_path(job)

      expect(page).to have_content(job.title)
      expect(page).to have_content(job.skill.name)
      expect(page).to have_content(job.min_price)
      expect(page).to have_content(job.max_price)
      expect(page).to have_content(job.description)
      expect(page).to have_button('Send Message')
    end
  end

  # context 'requester visits pages and cannot send message' do
  #   it 'sees job title, skill, price range, description and edit option' do
  #     requester = create(:requester)
  #     ApplicationController.any_instance.stubs(:current_user).returns(requester)
  #     job = Job.create(
  #       title: 'test job',
  #       skill: create(:skill),
  #       min_price: 100,
  #       max_price: 1000,
  #       requester: requester,
  #       status: 'available',
  #       description: 'do the thing'
  #     )
  #     visit job_path(job)
  #
  #     expect(page).to have_content(job.title)
  #     expect(page).to have_content(job.skill)
  #     expect(page).to have_content(job.min_price)
  #     expect(page).to have_content(job.max_price)
  #     expect(page).to have_content(job.description)
  #     expect(paeg).to_not have_button('Send Message')
  #     expect(page).to have_button('Edit Job Information')
  #   end
  # end

  # context 'requester cannot see other requesters jobs' do
  #   it 'sees error' do
  #     requester = create(:requester)
  #     ApplicationController.any_instance.stubs(:current_user).returns(requester)
  #     job = create(:job)
  #     visit job_path(job)
  #
  #     expect(page).to have_content('404')
  #     expect(page).to have_content('Page does not exist')
  #   end
  # end
end
