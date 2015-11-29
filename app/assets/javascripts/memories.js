$(document).on('ready page:load', function() {
  $('.generate_memories').on('submit', function(e) {
    e.preventDefault();
    $('#loading').show();
    $('.update').hide();
    $('.update').text('This could take a while.');
    $('.update').delay(3000).fadeIn();
    var form = $(this)[0];

    $.post(form.action, {"source":  form.source.value}, function(data) {
      $('.update').fadeOut();
      $('#loading').fadeOut(function(){
        $('.update').text(data['memories_count'] + " memories imported");
        $('.update').fadeIn();
      });
    });

  });
});
