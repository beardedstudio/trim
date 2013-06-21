(function($){

  $(document).ready(function(){
    var $help = $('div.text_type.teaser_field .help-block');
    var $input = $('div.text_type.teaser_field textarea');
    var $count = $('<span>').addClass('char-count').html($input.val() ? $input.val().length : 0);

    $help
      .html('Featured text is limited to 150 characters.  Current Count: ')
      .append($count)
      .append('.');

    $input
      .keyup(function() {
        $count.text( $(this).val().replace(/{.*}/g, '').length );
      });
  });

}(jQuery))