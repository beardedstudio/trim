class User < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  attr_accessible :provider, :uid, :as => :admin

  validates :email, :uniqueness => true

  def to_s
    name.blank? ? email : name
  end

  alias_method :title, :to_s

  def self.find_for_openid(access_token, signed_in_resource=nil)
    data = access_token.info

    if user = User.find_by_email(data["email"])
      user

    # Create a user with a stub password.
    else
      name = [data['first_name'], data['last_name']].join(' ')
      password = Devise.friendly_token[0,20]

      u = User.new( { :email => data["email"],
                      :name => name,
                      :password => password,
                      :pasword_confirmation => password }, :as => :admin )

      u.skip_confirmation!
      u.save
      u
    end
  end
end