$reorderable = $('tbody.table-reorderable')

preserveTableRows = (e, tr) -> 
  $orig = tr.children();
  $temp = tr.clone();
  $temp.children().each (idx)->
    $(this).width($orig.eq(idx).width())
  return $temp;

refreshSorts = (e, ui) ->
  postData = []
  postData.push("ajax=true")
  # update the weights.
  $('select.sort').each ->
    $(this).val($(this).closest('tr').index())
  # prepare an object to submit.
    postData.push("item[#{$(this).attr('id').replace(/sort-/, '')}]=#{$(this).val()}")
  # post it up.
  $.post window.location.pathname, postData.join("&"), (data, textStatus) ->
    $message = $('<div class="alert"><a class="close" data-dismiss="alert" href="#">×</a></div>')
    if (data.hasOwnProperty('success'))
      $message.addClass('alert-success').append('Saved successfully!')
    else
      $message.addClass('alert-error').append('There was a problem saving the order of the items')

    $('ul.breadcrumb').after($message);
    $message
      .on('click', -> $(this).stop().fadeOut(250, -> $(this).remove()))
      .animate({top: 0}, 5000).fadeOut(250, -> $(this).remove());

# hide header rows
$('.sort-header, .sort-division', $reorderable.parent()).add('#reorder_model_form_submit').hide()

$reorderable.sortable({
  cursor: 'pointer'
  helper: preserveTableRows
  scroll: true
  update: refreshSorts
}).disableSelection();
