$(function() {
  if ($('body.orders-steps.show').length || $('body.orders-steps.update').length) {
    // Telephone and postal code masking
    $("input[name='order[user_attributes][phone_number]']").mask("(000)-000-0000");
    $("input[name='order[address][postal_code]']").mask("A0A 0A0");

    jQuery.validator.addMethod("cdnPostal", function(postal, element) {
        return this.optional(element) ||
        postal.match(/[a-zA-Z][0-9][a-zA-Z](-| |)[0-9][a-zA-Z][0-9]/);
    }, "Please specify a valid postal code.");

    $.extend($.validator.messages, { equalTo: "Passwords do not match." })
    $('.simple_form.edit_order').validate({
      rules: {
        "order[user_attributes][first_name]": {required: true},
        "order[user_attributes][last_name]": {required: true},
        "order[user_attributes][phone_number]": {required: true, phoneUS: true},
        "order[user_attributes][occupation]": {required: true},
        "order[address][street_1]": {required: true},
        "order[address][street_2]": {required: false},
        "order[address][city]": {required: true},
        "order[address][country]": {required: true},
        "order[address][state]": {required: true},
        "order[address][postal_code]": {required: true, cdnPostal: true},
        "order[agree_to_deal_sheet_and_terms]": {required: true},
        "order[broker]": {required: true},
        "order[postal_code]": {required: true}
      },
      messages: {
        "order[agree_to_deal_sheet_and_terms]": {
          required: "You need to read and agree with our deal sheet as well as Terms & Conditions to confirm and pay for the selected unit."
        },
        "order[broker]": {
          required: "We're the first to give public access to our pre-sale to everyone. To get the best price you need to confirm you're not a broker and you didn't use any broker service to buy this unit."
        }
      },

      errorPlacement: function(error, element) {
        if ($(element).prop('id') === 'order_agree_to_deal_sheet_and_terms' || $(element).prop('id') === 'order_broker') {
          $(element).parents('.checkbox-label').append(error);
        } else {
          error.insertAfter(element);
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

    Selectize.define('hidden_textfield', function(options) {
      var self = this;
      this.showInput = function() {
        this.$control.css({cursor: 'pointer'});
        this.$control_input.css({opacity: 0, position: 'relative', left: self.rtl ? 10000 : -10000 });
        this.isInputHidden = false;
      };

      this.setup_original = this.setup;

      this.setup = function() {
        self.setup_original();
        this.$control_input.prop("disabled","disabled");
      }
    });

    $('.selectize').selectize({
      create: true,
      sortField: 'text',
      plugins: ['hidden_textfield'],
      hideSelected: true,
      onDropdownOpen: function () {
        $('.selectize-input').prop('disabled',true).off('click');
      }
    });
  }
});
