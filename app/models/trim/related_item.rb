module Trim
  class RelatedItem < ActiveRecord::Base

    belongs_to :related_to, :inverse_of => :relating_items, :polymorphic => true
    belongs_to :related_from, :inverse_of => :related_items, :polymorphic => true

    delegate :title, :to => :related_to, :allow_nil => true
    delegate :excerpt, :to => :related_to, :allow_nil => true

    validates :related_to, :presence => true

    default_scope order('sort ASC')

    rails_admin do
      visible false

      nested do
        field :related_to
        field :sort
      end
    end

  end
end
