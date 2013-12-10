require 'machinist/active_record'

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

  Setting.email_configuration.each do |name, params|
    send("#{name}_body") { Setting.email_placeholder_string name }
    send("#{name}_subject") { Setting.email_placeholder_string name }
  end
end

Trim::Page.blueprint do
  title { "Page #{sn}" }
  body { 'Lorem ipsum dolor' }
end

def get_testing_image
  File.new Rails.root.join("../support/test-image.jpg")
end
