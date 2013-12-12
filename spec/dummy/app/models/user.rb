class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :name, :title, :body
  rails_admin do
    navigation_label 'Users'

    include_fields :name, :email, :created_at

    show do
      fields :updated_at, :sign_in_count, :current_sign_in_ip, :last_sign_in_ip
    end

    edit do
      fields :password, :password_confirmation
    end
  end
end
