(function($) {

  var reindexSort = function($controls, fieldName) {
    $controls.find('a[data-toggle=tab]').each(function(index){
      $($(this).attr('href'))
        .find('div.'+fieldName+'_field')
        .hide()
        .find('input')
        .val(index);
    });
  }

  var sortableSetup = function(){
    $context = $('[data-pjax-container]')
    $context.find('[data-nestedmany][data-sortable]').each(function(){
      var $controls = $(this);
      var $sortable = $controls.find('ul.nav-tabs');
      var fieldName = $controls.data('sortable');
      reindexSort($controls, fieldName);

      $sortable.sortable({
        update: function(event, ui) {
          reindexSort($controls, fieldName);
        }
      });
    });
  }

  // Set things up when a nested form is added.
  $(document).on('nested:fieldAdded', 'form', function (content) {
    var $controls = content.field
      .parents('.tab-content').first().prev('[data-sortable]');
    if ($controls.length) {
      fieldName = $controls.data('sortable');
      reindexSort($controls, fieldName);
    }
  });

  // Set things up on document load, and on PJAX completion.
  $(document).on('pjax:end', sortableSetup).on('ready', sortableSetup);

})(jQuery);
