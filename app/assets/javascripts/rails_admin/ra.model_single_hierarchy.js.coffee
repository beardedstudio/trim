$ = jQuery

$ ->

  $sort = $('.services-tree');
  if $sort.length isnt 0
    $sort.nestedSortable
      disableNesting: 'no-nest',
      forcePlaceholderSize: true,
      handle: 'div.item',
      helper:  'clone',
      items: 'li',
      maxLevels: 2,
      opacity: .6,
      placeholder: 'placeholder',
      revert: 250,
      tabSize: 25,
      tolerance: 'pointer',
      toleranceElement: '> div',
      protectRoot: false,
      update: (event, ui) ->
        $tree = $(this);
        tree_string = $tree.nestedSortable('serialize');
        # Extract the root nav from the URL if present.
        match = window.location.href.match(/&root=[a-z]+/g)
        tree_string += match if match?
        $.post window.location.pathname, tree_string, (data, textStatus) ->
          # TODO: detect failure
          $message = $('<div class="alert alert-success" />');
          # It's weird to stick this in the sidebar, but it prevents the page
          # layout from changing.
          $('ol.services-tree').before($message);
          $message.html('Saved successfully!')
            .animate({top: 0}, 5000)
            .fadeOut();

