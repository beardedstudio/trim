RSpec.configure do |config| 
  config.before :each do
    [Trim::LeadImage, Trim::Image, Trim::Download].each do |model| 
      model.any_instance.stub(:save_attached_files).and_return(true)
      model.any_instance.stub(:delete_attached_files).and_return(true)
    end

    Paperclip::Attachment.any_instance.stub(:post_process).and_return(true)
  end
end
