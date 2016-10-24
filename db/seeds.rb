class Seed
  def self.start(num_requesters, num_professionals)
    seed = Seed.new
    seed.create_requester(num_requesters)
    seed.create_professional(num_professionals)
  end

  def create_requester(num)
    num.times do |i|
      user = User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.cell_phone,
        street_address: Faker::Address.street_address,
        city: Faker::Address.city,
        zipcode: Faker::Address.zip_code,
        password: Faker::Internet.password,
        role: "requester",
        state: Faker::Address.state_abbr,
        verified: true
      )
      puts "Requester user #{i}: #{user.full_name} - #{user.email} created"
    end
  end

  def create_professional(num)
    num.times do |i|
      user = User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.cell_phone,
        street_address: Faker::Address.street_address,
        city: Faker::Address.city,
        zipcode: Faker::Address.zip_code,
        password: Faker::Internet.password,
        role: "professional",
        business_name: Faker::Company.name,
        state: Faker::Address.state_abbr,
        verified: true
      )
      puts "Professional user #{i}: #{user.business_name} - #{user.email} created"
    end
  end
end

Seed.start(100,100)
