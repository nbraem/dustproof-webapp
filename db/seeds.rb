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
  user.measurements.create! seq: i,
                            timestamp: Time.now,
                            temperature: rand(25).to_f,
                            humidity: rand(100).to_f,
                            p1_concentration: rand(50000),
                            p1_filtered: rand(50000),
                            p1_lpo: rand(50000),
                            p1_ratio: rand.round(2),
                            p2_concentration: rand(50000),
                            p2_filtered: rand(50000),
                            p2_lpo: rand(50000),
                            p2_ratio: rand.round(2)
end
