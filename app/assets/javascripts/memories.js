$(document).on('ready page:load', function() {
  $('.generate_memories').on('submit', function(e) {
    e.preventDefault();
    var form = this;

    $('#initial_loading').fadeIn();

    $('.update').hide();
    $('.update').text('This could take a while.');
    $('.update').delay(3000).fadeIn();

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

  $('#import_latest').on('submit', function(e) {
    e.preventDefault();
    var form = this;

    $(this).fadeOut(function() {
      $('#latest_loading').css({"display": "inline-block"});
      $('#latest_loading').fadeIn();
    });


    $.post(form.action, function(data) {

      $('#latest_loading').fadeOut(function() {
        $('#complete').css({"display": "inline-block"});
        $('#complete').fadeIn();
        $(form).remove();
      });
    });
  });

});
