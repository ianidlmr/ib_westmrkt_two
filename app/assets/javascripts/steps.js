$(function() {
  $.extend($.validator.messages, { equalTo: "Passwords do not match." })
  $('.simple_form.edit_order').validate({
    rules: {
      "order[user_attributes][first_naem]": {required: true},
      "order[user_attributes][last_name]": {required: true},
      "order[user_attributes][phone_number]": {required: true},
      "order[user_attributes][occupation]": {required: true},
      "order[address][street_1]": {required: true},
      "order[address][city]": {required: true},
      "order[address][state]": {required: true},
      "order[address][postal_code]": {required: true}
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
});
