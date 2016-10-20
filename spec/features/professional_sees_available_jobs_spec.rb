require 'rails_helper'

describe 'professional looks at jobs' do
  it 'sees all jobs for their state and skills' do
    pro = create_professional
    skill = pro.skills.last
    state = pro.state

    job_1 = create(:job, title: 'Job 1', state: 'CO', skill: skill)
    job_2 = create(:job, title: 'Job 2', state: 'CO')
    job_3 = create(:job, title: 'Job 3', state: 'WA', skill: skill)
    
    ApplicationController.any_instance.stubs(:current_user).returns(pro)

    visit professionals_jobs_path

    expect(page).to have_content('Job 1')
    expect(page).not_to have_content('Job 2')
    expect(page).not_to have_content('Job 3')
  end
end
