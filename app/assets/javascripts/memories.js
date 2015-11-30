$(document).on('ready page:load', function() {
  $('.generate_memories').on('submit', function(e) {
    e.preventDefault();
    $('#initial_loading').show();
    $('.update').hide();
    $('.update').text('This could take a while.');
    $('.update').delay(3000).fadeIn();
    var form = $(this)[0];

    $.post(form.action, {"source":  form.source.value}, function(data) {
      $('.update').fadeOut();
      $('#initial_loading').fadeOut(function(){
        $('.update').text(data['memories_count'] + " memories imported");
        $('.update').fadeIn();
        if(data['memories_count'] > 0) {
          $(form).children('input[type=submit]').prop('disabled', true);
        }
      });
    });

  });

  $('#import_latest').on('submit', function() {
    $(this).hide();
    $('#latest_loading').show();
    $.post(form.action, function(data) {
    });
  });

});
