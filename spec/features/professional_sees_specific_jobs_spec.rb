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
      expect(page).to have_content(job.min_price / 100)
      expect(page).to have_content(job.max_price / 100)
      expect(page).to have_content(job.description)
      expect(page).to have_button('Start Conversation')
    end
  end

  context 'requester visits pages and cannot send message' do
    it 'sees job title, skill, price range, description and edit option' do
      requester = create(:user)
      requester.update(role: 'requester')
      ApplicationController.any_instance.stubs(:current_user).returns(requester)
      job = Job.create(
        title: 'test job',
        skill: create(:skill),
        min_price: 100,
        max_price: 1000,
        requester_id: requester.id,
        status: 'available',
        description: 'do the thing'
      )
      visit job_path(job)

      expect(page).to have_content(job.title)
      expect(page).to have_content(job.skill.name)
      expect(page).to have_content(job.min_price / 100)
      expect(page).to have_content(job.max_price / 100)
      expect(page).to have_content(job.description)
      expect(page).to_not have_button('Send Message')
    end
  end

  context 'requester cannot see other requesters jobs' do
    it 'sees error' do
      requester = create(:requester)
      ApplicationController.any_instance.stubs(:current_user).returns(requester)
      job = create(:job)
      visit job_path(job)

      expect(page.status_code).to have_content('404')
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
