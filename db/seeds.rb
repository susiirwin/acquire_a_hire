class Seed
  def self.start(num_requesters, num_professionals, num_jobs)
    seed = Seed.new
    seed.create_skills
    seed.create_requester(num_requesters)
    seed.create_professional(num_professionals)
    seed.create_jobs(num_jobs)
  end

  def create_skills
    Skill.create(name: "Plumbing")
    Skill.create(name: "Carpentry")
    Skill.create(name: "Tailoring")
    Skill.create(name: "Web Development")
    Skill.create(name: "Blacksmithing")
    Skill.create(name: "Electrician")
    Skill.create(name: "General Contractor")
    Skill.create(name: "Yoga")
    Skill.create(name: "Mechanic")
    Skill.create(name: "Animal Services")
  end

  def create_requester(num)
    num.times do |i|
      email = Faker::Internet.email
      while User.find_by(email: email) do
        email = Faker::Internet.email
      end
      user = User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: email,
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
      email = Faker::Internet.email
      while User.find_by(email: email) do
        email = Faker::Internet.email
      end
      user = User.new(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: email,
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
      user.skills << Skill.find(rand(1..(Skill.count)))
      user.save!
      puts "Professional user #{i}: #{user.business_name} - #{user.email} created"
    end
  end

  def create_jobs(num)
    num.times do |i|
      random_requester = User.where(role: "requester").shuffle.pop
      job = Job.create(
        title: Faker::Company.catch_phrase,
        skill: Skill.find(rand(1..(Skill.count))),
        min_price: rand(1000),
        max_price: rand(1000..10000),
        requester: random_requester,
        status: "available",
        description: Faker::StarWars.quote,
        state: random_requester.state
      )
      puts "Job #{i}: #{job.title} - #{job.skill.name} created"
    end
    assign_jobs(num / 2)
  end

  def assign_jobs(num)
    num.times do |i|
      rand_job = Job.all.shuffle.pop
      random_professional = User.where(role: "professional").shuffle.pop
      status = ["pending", "closed"].shuffle.pop
      rand_job.update_attributes(professional: random_professional, status: status)
    end
  end
end

Seed.start(50, 50, 200)
