$(function() {
  $('.alert').not('.alert-danger').delay(3000).slideUp(750);
  $("input[name='unit_number']").mask("000000000");

  // Sidebar
  $('body').on('touchstart click', function(e) {
    if ($(e.target).hasClass('hamburger-container') || $(e.target).hasClass('menu-hamburger') || $(e.target).hasClass('menu-title')) {
      showMask();
      $('.sidebar').addClass('sidebar-is-open');
      $('.sidebar').css({'box-shadow': 'rgba(26, 26, 26, 0.2) 5px 0px 20px 5px'});
      $('.right-sidebar').removeClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': 'none'});
    } else if ($(e.target).hasClass('saved-icon')) {
      showMask();
      $('.sidebar').removeClass('sidebar-is-open');
      $('.sidebar').css({'box-shadow': 'none'});
      $('.right-sidebar').addClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': 'rgba(26, 26, 26, 0.2) 5px 0px 20px 5px'});
    } else if (!$(e.target).hasClass('sidebar') && !$(e.target).parents('.sidebar').length && $('.sidebar').hasClass('sidebar-is-open')) {
      hideMask();
      $('.sidebar').css({'box-shadow': 'none'});
      $('.sidebar').removeClass('sidebar-is-open');
    } else if (!$(e.target).hasClass('right-sidebar') && !$(e.target).parents('.right-sidebar').length && $('.right-sidebar').hasClass('right-sidebar-is-open') && !$(e.target).hasClass('modal') && !$(e.target).parents('.modal').length) {
      hideMask();
      $('.right-sidebar').removeClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': 'none'});
    }
  });

  // Input styling
  $('.input-text-wrap input').each(function(index, node) {
    if (node.value.length > 0 && node.value != ' ') {
      $(node).closest('.input-text-wrap').removeClass('is-focused');
    } else {
      $(this).closest('.input-text-wrap').addClass('is-focused');
    }
  });

  $('.input-text-wrap input').on('focus', function(e) {
    if (!$(e.target).val().length) {
      $(this).closest('.input-text-wrap').addClass('is-focused');
    }
  });

  var EnterClicked = false;

  $('.custom-search-button').mousedown(function() {
    EnterClicked = true;
  })
  .mouseup(function() {
    EnterClicked = false
  });

  $('.input-text-wrap input').on('blur', function(e) {
    if (!$(e.target).val().length && !EnterClicked) {
      $(this).closest('.input-text-wrap').removeClass('is-focused');
    }
  });

  // Sign up validation
  $.extend($.validator.messages, { equalTo: "Passwords do not match." })
  $('.sign-up-new-user').validate({
    rules: {
      "user[email]": {required: true, email: true},
      "user[first_name]": {required: true},
      "user[last_name]": {required: true},
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

  $(document).on('ajax:success', '.sign-up-new-user', function(e) {
    window.location.reload(true);
    sessionStorage.setItem('signup-success', true);
  });

  if (sessionStorage.getItem('signup-success')) {
    var successAlert = '<div class="alert alert-success">' +
      '<button class="close" "aria-hidden"="true" "data-dismiss"="alert" "type"="button">' +
        '×' +
      '</button>' +
      '<div id="flash_success">' +
        'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.' +
      '</div>' +
    '</div>';

    if ($('.navbar.secondary').length > 0) {
      $('.navbar.secondary').after(successAlert);
    } else {
      $('.navbar').after(successAlert);
    }

    $('.alert').not('.alert-danger').delay(3000).slideUp(750);
    sessionStorage.removeItem('signup-success');
  };

  $(document).on('ajax:error', '.sign-up-new-user', function(event, xhr, settings, exceptions) {
    $('.signup-alert').remove();
    var $form = $('.sign-up-new-user');
    $form.prepend('<div class="alert alert-danger signup-alert">Email has already been taken.</div>');
  });

  $('.login-user').validate({
    rules: {
      "user[email]": {required: true, email: true},
      "user[password]": {required: true, minlength: 8}
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

  // Log in validation
  $(document).on('ajax:success', '.login-user', function(e) {
    window.location.reload(true);
    sessionStorage.setItem('login-success', true);
  });

  if (sessionStorage.getItem('login-success')) {
    var successAlert = '<div class="alert alert-success">' +
      '<button class="close" "aria-hidden"="true" "data-dismiss"="alert" "type"="button">' +
        '×' +
      '</button>' +
      '<div id="flash_success">' +
        'Signed in successfully.' +
      '</div>' +
    '</div>';

    if ($('.navbar.secondary').length > 0) {
      $('.navbar.secondary').after(successAlert);
    } else {
      $('.navbar').after(successAlert);
    }

    $('.alert').not('.alert-danger').delay(3000).slideUp(750);
    sessionStorage.removeItem('login-success');
  }

  $(document).on('ajax:error', '.login-user', function(event, xhr, settings, exceptions) {
    $('.login-alert').remove();
    var $form = $('.login-user');
    $form.prepend('<div class="alert alert-danger login-alert">' + xhr.responseText +'</div>');
  });

  // Reset password validation
  $(document).on('ajax:success', '.reset-password-user', function(e) {
    window.location.reload(true);
    sessionStorage.setItem('reset-password-success', true);
  });

  if (sessionStorage.getItem('reset-password-success')) {
    var successAlert = '<div class="alert alert-success">' +
      '<button class="close" "aria-hidden"="true" "data-dismiss"="alert" "type"="button">' +
        '×' +
      '</button>' +
      '<div id="flash_success">' +
        'You will receive an email with instructions on how to reset your password in a few minutes.' +
      '</div>' +
    '</div>';

    if ($('.navbar.secondary').length > 0) {
      $('.navbar.secondary').after(successAlert);
    } else {
      $('.navbar').after(successAlert);
    }

    $('.alert').not('.alert-danger').delay(3000).slideUp(750);
    sessionStorage.removeItem('reset-password-success');
  }

  $(document).on('ajax:error', '.reset-password-user', function(event, xhr, settings, exceptions) {
    $('.reset-password-alert').remove();
    var $form = $('.reset-password-user');
    $form.prepend('<div class="alert alert-danger reset-password-alert">' + xhr.responseText +'</div>');
  });

  // Open saved unit on click
  $('body').on('click', '.saved-unit', function(e) {
    var thisUnit = this;
    var $savedUnits = $('.saved-units-container').find('.saved-unit');

    $savedUnits.each(function (i, node) {
      var $option = $(node);
      if (thisUnit == node) {
        $(thisUnit).children('.btn-checkout-container, .delete-icon').removeClass('hidden');
        $(thisUnit).children('.people-saved').css({'color': 'black'});
        $(thisUnit).css({'background': '#f5f5f5'});
      } else {
        $option.children('.btn-checkout-container, .delete-icon').addClass('hidden');
        $option.children('.people-saved').css({'color': '#ccc'});
        $option.css({'background': '#fff'});
      }
    });
  });

  // Floating box margin
  if ($('#floating-box').length) {
    if ($(window).width() >= 768) {
      var offset = ($(window).width() - $('.container-fluid.special').outerWidth()) / 2;
      $('#floating-box').css({'right': offset + 'px'});
    }

    var resizeTimer;
    $(window).on('resize', function(e) {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function() {
        if ($(window).width() >= 768) {
          var offset = ($(window).width() - $('.container-fluid.special').outerWidth()) / 2;
          $('#floating-box').css({'right': offset + 'px'});
        } else {
          $('#floating-box').css({'right': '0px'});
        }
      }, 250);
    });

    // Floating box scroll
    $('body').scroll(function() {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function() {
        if ($(window).width() >= 768) {
          if($('#floating-box').offset().top + $('#floating-box').height() >= $('footer').offset().top - 50) {
            $('#floating-box').css({'position': 'absolute', 'bottom': '90px', 'top': 'auto', 'margin-right': '0px'});
          }

          if($('body').scrollTop() + window.innerHeight < $('footer').offset().top + 50) {
            $('#floating-box').css({'position': 'fixed', 'top': '60px', 'bottom': 'auto', 'margin-right': '15px'});
          }
        }
      }, 50);
    });
  }
});

function showMask() {
  $('.mask').css({'display': 'block'});
}

function hideMask() {
  $('.mask').css({'display': 'none'});
}
