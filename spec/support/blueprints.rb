require 'machinist/active_record'

Trim::Image.blueprint do
  caption { "This is a great image!" }
  alt_text { "A picture of a cartoon spaceship" }
  image { get_testing_image }
end

Trim::Nav.blueprint do
  title { "Nav #{sn}" }
  slug { "nav-#{sn}" }
  priority { 0 }
  nav_item { Trim::NavItem.make! :menu_root }
end

Trim::NavItem.blueprint do
  title { "Nav Item #{sn}" }
end

Trim::NavItem.blueprint :menu_root do
  nav_path {''}
  bypass_callbacks { true }
end

Trim::Page.blueprint do
  title { "Page #{sn}" }
  body { 'Lorem ipsum dolor' }
end

Trim::Page.blueprint :private do
  is_private { true }
end

Trim::Setting.blueprint do
  twitter_name { 'beardedstudio' }
  facebook_url { 'https://www.facebook.com/beardedstudio' }
  street_address { '6101 Penn Avenue, Suite 302' }
  city { 'Pittsburgh' }
  state { 'PA' }
  zip_code { '15206' }
  phone_number { '412.376.7273' }
  contact_email { 'info@bearded.com' }
  meta_description { 'A Pittsburgh, PA-based Web Design and Development Studio' }
  meta_keywords { 'Beard, Internet, Web, Doge, Website' }

  Trim::Setting.email_configuration.each do |name, params|
    send("#{name}_body") { Trim::Setting.email_placeholder_string name }
    send("#{name}_subject") { name }
  end
end

Trim::RelatedItem.blueprint do
  related_to { Trim::Page.make! }
end

Trim::Video.blueprint do
  caption { 'This is a Video' }
end

User.blueprint do
  email { "person#{sn}@example.com" }
  password { 'password' }
  password_confirmation { 'password' }
end

def get_testing_image
  File.new Rails.root.join("../support/test-image.jpg")
end
