$ = jQuery

$ ->
  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    controls = $(link).closest(".controls")
    tab_content = controls.siblings(".tab-content")
    tab_content.append content
    tab_content.children().last()
