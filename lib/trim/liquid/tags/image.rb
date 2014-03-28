class Image < Liquid::Tag

  def initialize(tag_name, index, tokens)
     super
     @index = index.to_i - 1
  end

  def render(context)
    item = context.environments.first[:renderable_context]

    if item && item.respond_to?(:images)

      image = item.images[@index]

      if image
        controller = ActionController::Base.new
        return controller.render_to_string :partial => 'trim/images/inserted', :object => image
      end
    end
  end
end

Liquid::Template.register_tag 'image', Image
