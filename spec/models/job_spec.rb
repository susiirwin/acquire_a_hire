require 'rails_helper'

RSpec.describe Job, type: :model do
  it "has "

  it "requires min price less than max price" do
    job = create(:job, min_price: 100, max_price: 200)
    expect(job.valid?).to be true

    job.min_price = 200
    job.max_price = 100

    expect(job.invalid?).to be true
  end
end
