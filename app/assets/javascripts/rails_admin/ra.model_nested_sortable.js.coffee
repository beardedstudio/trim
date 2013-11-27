$ = jQuery

$ ->

  $sort = $('#model_nested_sortable');
  if $sort.length isnt 0
    $sort.nestedSortable
      disableNesting: 'no-nest',
      forcePlaceholderSize: true,
      handle: 'div',
      helper:  'clone',
      items: 'li',
      maxLevels: 10,
      opacity: .6,
      placeholder: 'placeholder',
      revert: 250,
      tabSize: 25,
      tolerance: 'pointer',
      toleranceElement: '> div',
      protectRoot: true,
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
          $('.well.sidebar-nav').after($message);
          $message.html('Saved successfully!')
            .animate({top: 0}, 5000)
            .fadeOut();

