user = User.find_by_email 'admin@example.com'

User.create!( :email => 'admin@example.com',
              :name => 'Administrator',
              :password => 'password',
              :password_confirmation => 'password') if user.nil?

Trim::Nav.rebuild_navs!
