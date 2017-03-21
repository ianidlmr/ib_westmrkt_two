$(function() {
  $('.input-text-wrap input').on('focus', function() {
    $(this).closest('.input-text-wrap').addClass('is-focused');
  });

  $('.input-text-wrap input').on('blur', function(e) {
    if (!$(e.target).val().length) {
      $(this).closest('.input-text-wrap').removeClass('is-focused');
    }
  });

  $('body').on('click', function(e) {
    // e.preventDefault();
    if ($(e.target).hasClass('hamburger-icon')) {
      $('.sidebar').addClass('sidebar-is-open');
    } else if ($(e.target).hasClass('saved-icon')) {
      $('.right-sidebar').addClass('right-sidebar-is-open');
    } else if (!$(e.target).hasClass('sidebar') && !$(e.target).parents('.sidebar').length && $('.sidebar').hasClass('sidebar-is-open')) {
      $('.sidebar').removeClass('sidebar-is-open');
    } else if (!$(e.target).hasClass('right-sidebar') && !$(e.target).parents('.right-sidebar').length && $('.right-sidebar').hasClass('right-sidebar-is-open')) {
      $('.right-sidebar').removeClass('right-sidebar-is-open');
    }
  });


  $('.simple_form.new_user').validate({
    rules: {
      email: {
        required: true,
        email: true
      },
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
