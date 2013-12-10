class Video < Liquid::Tag

  def initialize(tag_name, index, tokens)
     super
     @index = index.to_i - 1
  end

  def render(context)
    item = context.environments.first[:renderable_context]

    if item && item.respond_to?(:videos)
      video = item.videos[@index]

      if video
        controller = ActionController::Base.new
        controller.render_to_string :partial => 'videos/inserted', :object => video
      end
    end
  end
end

Liquid::Template.register_tag 'video', Video
