$(function() {
  $('.alert').not('.alert-danger').delay(3000).slideUp(750);

  $('body').on('click', function(e) {
    if ($(e.target).hasClass('hamburger-icon')) {
      showMask();
      $('.sidebar').addClass('sidebar-is-open');
      $('.sidebar').css({'box-shadow': '5px 0 20px -5px #888'});
      $('.right-sidebar').removeClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': 'none'});
    } else if ($(e.target).hasClass('saved-icon')) {
      showMask();
      $('.sidebar').removeClass('sidebar-is-open');
      $('.sidebar').css({'box-shadow': 'none'});
      $('.right-sidebar').addClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': '5px 0 20px 5px #888'});
    } else if (!$(e.target).hasClass('sidebar') && !$(e.target).parents('.sidebar').length && $('.sidebar').hasClass('sidebar-is-open')) {
      hideMask();
      $('.sidebar').css({'box-shadow': 'none'});
      $('.sidebar').removeClass('sidebar-is-open');
    } else if (!$(e.target).hasClass('right-sidebar') && !$(e.target).parents('.right-sidebar').length && $('.right-sidebar').hasClass('right-sidebar-is-open')) {
      hideMask();
      $('.right-sidebar').removeClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': 'none'});
    }
  });

  $('.input-text-wrap input').on('focus', function() {
    $(this).closest('.input-text-wrap').addClass('is-focused');
  });

  $('.input-text-wrap input').on('blur', function(e) {
    if (!$(e.target).val().length) {
      $(this).closest('.input-text-wrap').removeClass('is-focused');
    }
  });

  $('.selectize').selectize({
    create: false,
    sortField: 'text'
  });

  $.extend($.validator.messages, { equalTo: "Passwords do not match." })
  $('.simple_form.new_user').validate({
    rules: {
      "user[email]": {required: true, email: true},
      "user[password]": {required: true, minlength: 8},
      "user[password_confirmation]": {required: true, equalTo: "#user_password"}
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

  $(".countdown").countdown("2017/05/01", function(event) {
    var $this = $(this).html(event.strftime(''
    + '<span>%d</span>d '
    + '<span>%H</span>h '
    + '<span>%M</span>m '
    + '<span>%S</span>s'));
  });

  $('body').on('click', '.saved-unit', function(e) {
    var thisUnit = this;
    var $savedUnits = $('.saved-units-container').find('.saved-unit');

    $savedUnits.each(function (i, node) {
      var $option = $(node);
      if (thisUnit == node) {
        $(thisUnit).children('.btn-checkout-container, .close-icon').removeClass('hidden');
        $(thisUnit).children('.people-saved').css({'color': 'black'});
        $(thisUnit).css({'background': '#f5f5f5'});
      } else {
        $option.children('.btn-checkout-container, .close-icon').addClass('hidden');
        $option.children('.people-saved').css({'color': '#ccc'});
        $option.css({'background': '#fff'});
      }
    });
  });
});

function showMask() {
  $('.mask').css({'display': 'block'});
}

function hideMask() {
  $('.mask').css({'display': 'none'});
}
