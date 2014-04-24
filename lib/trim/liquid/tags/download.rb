class Download < Liquid::Tag

  def initialize(tag_name, index, tokens)
     super
     @index = index.to_i - 1
  end

  def render(context)
    item = context.environments.first[:renderable_context]
    if item && item.respond_to?(:downloads)
      download = item.downloads[@index]
      if download
        controller = ActionController::Base.new()
        return controller.render_to_string(:partial => 'trim/downloads/inserted', :object => download)
      end
    end
  end
end

Liquid::Template.register_tag('download', Download)
