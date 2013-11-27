(function($) {

  function expandOnError(){
    var $errorField, $errorDiv, errorsList, $errorsUl;
    $errorField = $('.control-group.error')

    // collect all the errors and show them up top, too
    $errorDiv = $('div.alert-error');
    errorsList = [];
    $('.control-group.error').each(function(e){
      errorsList.push($('.help-inline', $(this)).html());
    });

    $errorsUl = $('<ul>');
    $.each(errorsList, function(index, value){
      $errorsUl.append('<li>'+ value +'</li>');
    });
    $errorDiv.append($errorsUl);

    $errorField.each(function(){
      var $this, $assnParent, $fsParent, $errorTab, tabId;
      $this = $(this);

      // if we're in an association-tab, open it.
      $assnParent = $this.closest('.has_many_association_type');

      if ($assnParent.length > 0){
        // set the parent control's toggle arrow
        $assnParent.find('a.toggler').addClass('active').find('i').removeClass('icon-chevron-right').addClass('icon-chevron-down');
        // show the hidden things
        $assnParent.find('ul.nav-tabs, div.tab-content').show();
        // collect the tabs
        tabId = $this.closest('.tab-pane').attr('id');
        $assnParent.find('ul.nav-tabs').find('a[href=#'+ tabId +']').css({'font-weight' : 'bold', 'color' : '#b94a48'}).parent().addClass('error');
      }

      // if we're in a collapsible fieldset, open that too (all the way up)
      $fsParent = $this.parents('fieldset');

      if ($fsParent.length > 0){
        console.log('there is a fieldset');
        console.log($fsParent);
        console.log($fsParent.find('legend').html());
        $fsParent.find('legend i').removeClass('icon-chevron-right').addClass('icon-chevron-down');
        $fsParent.children('div.control-group').show();
      }

    });
  };

  $(document).on('ready pjax:end', expandOnError);

})(jQuery);