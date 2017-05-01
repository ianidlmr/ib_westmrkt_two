$(function() {
  if ($('body.orders-steps.show').length) {
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
        "order[broker]": {required: true},
        "order[postal_code]": {required: true}
      },
      messages: {
        "order[agree_to_deal_sheet_and_terms]": {
          required: "You need to read and agree with our dael sheet as well as Terms & Conditions to confirm and pay for the selected unit."
        },
        "order[broker]": {
          required: "We're the first to give pulic access to our pre-sale to everyone. To get the best price you need to confirm you're not a broker and you didn't use any broker service to buy this unit."
        }
      },

      errorPlacement: function(error, element) {
        if ($(element).prop('id') === 'order_agree_to_deal_sheet_and_terms' || $(element).prop('id') === 'order_broker') {
          $(element).parents('.checkbox-label').append(error);
        }
      },

      highlight: function(element, errorClass, validClass) {
        if ($(element).prop('id') === 'order_agree_to_deal_sheet_and_terms') {
          $('body.orders-steps.show .deal-sheet-text').css({'border-color': '#ff5353'});
        }
        $(element).parents('.input-text-wrap').children('.form-control-feedback').hide();
        $(element).parents('.input-text-wrap').children('.input-text-label').addClass('has-error');
        $(element).closest('.input-text-wrap input').removeClass('has-success').addClass('has-error');
      },

      success: function(element) {
        if ($(element).prop('id') === "order[agree_to_deal_sheet_and_terms]-error") {
          $('body.orders-steps.show .deal-sheet-text').css({'border-color': '#ccc'});
        }
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
  }
});
