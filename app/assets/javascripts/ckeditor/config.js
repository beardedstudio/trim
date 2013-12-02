CKEDITOR.editorConfig = function(config)
{
  config.toolbar_Basic = 
  [
    ['Bold', 'Italic', '-', 'RemoveFormat'],
    ['NumberedList', 'BulletedList', 'Outdent', 'Indent', 'Blockquote', 'Link', 'Unlink'],
    ['Sytles', 'Format']
  ];

  config.format_tags = 'p;h2;h3;h4;h5'

  config.toolbar = 'Basic';
}