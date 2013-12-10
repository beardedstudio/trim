require 'cancan/matchers'

def set_up_ability(options = {})
  options[:anonymous] ||= false
  @ability = Ability.new(options[:anonymous] ? User.make : User.make!)
end

describe "Ability" do

  describe "Administrators" do
    before :each do
      set_up_ability
    end

    [ Trim::Download, Trim::Image, Trim::LeadImage, Trim::Nav, Trim::NavItem,
      Trim::Page, Trim::RelatedItem, Trim::Setting, User].each do |model|

        specify { @ability.should be_able_to(:new, model.new) }
        specify { @ability.should be_able_to(:create, model.new) }
        specify { @ability.should be_able_to(:edit, model.new) }
        specify { @ability.should be_able_to(:update, model.new) }
        specify { @ability.should be_able_to(:show, model.new) }
        specify { @ability.should be_able_to(:index, model.new) }
        specify { @ability.should be_able_to(:destroy, model.new) }
    end
  end

  describe "Anonymous" do
    before :each do
      set_up_ability :anonymous => true
    end

    # Show only, not private
    context "Page" do
      specify { @ability.should_not be_able_to(:new, Trim::Page.make) }
      specify { @ability.should_not be_able_to(:create, Trim::Page.make) }
      specify { @ability.should_not be_able_to(:edit, Trim::Page.make) }
      specify { @ability.should_not be_able_to(:update, Trim::Page.make) }
      specify { @ability.should     be_able_to(:show, Trim::Page.make) }
      specify { @ability.should_not be_able_to(:show, Trim::Page.make(:private)) }
      specify { @ability.should_not be_able_to(:index, Trim::Page.make) }
      specify { @ability.should_not be_able_to(:destroy, Trim::Page.make) }
    end

    # Show only
    context "NavItem" do
      specify { @ability.should_not be_able_to(:new, Trim::NavItem.make) }
      specify { @ability.should_not be_able_to(:create, Trim::NavItem.make) }
      specify { @ability.should_not be_able_to(:edit, Trim::NavItem.make) }
      specify { @ability.should_not be_able_to(:update, Trim::NavItem.make) }
      specify { @ability.should     be_able_to(:show, Trim::NavItem.make) }
      specify { @ability.should_not be_able_to(:index, Trim::NavItem.make) }
      specify { @ability.should_not be_able_to(:destroy, Trim::NavItem.make) }
    end

    # No access
    [ Trim::Download, Trim::Image, Trim::LeadImage, Trim::Nav,
      Trim::RelatedItem, Trim::Setting, User ].each do |model|
      context "#{model}" do
        specify { @ability.should_not be_able_to(:new, model.new) }
        specify { @ability.should_not be_able_to(:create, model.new) }
        specify { @ability.should_not be_able_to(:edit, model.new) }
        specify { @ability.should_not be_able_to(:update, model.new) }
        specify { @ability.should_not be_able_to(:show, model.new) }
        specify { @ability.should_not be_able_to(:index, model.new) }
        specify { @ability.should_not be_able_to(:destroy, model.new) }
      end
    end
  end
end
