$(function() {
  $.extend($.validator.messages, { equalTo: "Passwords do not match." })
  $('.simple_form.edit_order').validate({
    rules: {
      "order[user_attributes][first_name]": {required: true},
      "order[user_attributes][last_name]": {required: true},
      "order[user_attributes][phone_number]": {required: true},
      "order[user_attributes][occupation]": {required: true},
      "order[address][street_1]": {required: true},
      "order[address][street_2]": {required: false},
      "order[address][city]": {required: true},
      "order[address][country_code]": {required: true},
      "order[address][state]": {required: true},
      "order[address][postal_code]": {required: true},
      "order[agree_to_deal_sheet_and_terms]": {required: true},
      "order[postal_code]": {required: true}
    },

    highlight: function(element, errorClass, validClass) {
      $(element).parents('.input-text-wrap').children('.form-control-feedback').hide();
      $(element).parents('.input-text-wrap').children('.input-text-label').addClass('has-error');
      $(element).closest('.input-text-wrap input').removeClass('has-success').addClass('has-error');
    },

    success: function(element) {
      $(element).parents('.input-text-wrap').children('.form-control-feedback').show();
      $(element).parents('.input-text-wrap').children('.input-text-label').removeClass('has-error');
      $(element).parent().children('input').removeClass('has-error');
      $(element).remove();
    }
  });

  if ($(window).width() >= 768) {
    var offset = ($(window).width() - $('.container').outerWidth()) / 2;
    $('#floating-box').css({'right': offset + 'px'});
  }

  $('.wrapper').scroll(function() {
    if ($(window).width() >= 768) {
      if($('#floating-box').offset().top + $('#floating-box').height() >= $('footer').offset().top - 30) {
        $('#floating-box').css({'position': 'absolute', 'bottom': '50px', 'top': 'auto'});
      }

      if($('.wrapper').scrollTop() < $('footer').offset().top + 400) {
        $('#floating-box').css({'position': 'fixed', 'top': '60px', 'bottom': 'auto'});
      }
    }
  });

});
