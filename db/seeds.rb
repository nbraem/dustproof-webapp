User.destroy_all

user = User.create! first_name: "Nikolai",
                    last_name: "Tesla",
                    email: "niko@dustproof.be",
                    password: "secret",
                    admin: false

admin = User.create! first_name: "Addo",
                     last_name: "Admin",
                     email: "admin@dustproof.be",
                     password: "secret",
                     admin: true

50.times do |i|
  user.measurements.create! timestamp: Time.now + i * 10.seconds,
                            temperature: rand(25).to_f,
                            humidity: rand(100).to_f,
                            pm25_ratio: rand(3500) / 100.to_f,
                            p1_ratio: rand(3500) / 100.to_f,
                            p2_ratio: rand(3500) / 100.to_f,
                            p1_count: rand(20),
                            p2_count: rand(20)
end
