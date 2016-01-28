User.destroy_all

User.create! first_name: "Nikolai",
             last_name: "Tesla",
             email: "niko@dustproof.be",
             password: "secret",
             admin: false

User.create! first_name: "Addo",
             last_name: "Admin",
             email: "admin@dustproof.be",
             password: "secret",
             admin: true
