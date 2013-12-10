module MailerHelpers
  include ActionView::Helpers::NumberHelper

  def last_email(step = 1)
    ActionMailer::Base.deliveries[-step]
  end
  
  def reset_email
    ActionMailer::Base.deliveries = []
  end
end