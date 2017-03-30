$(function() {
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

  $('body').on('click', function(e) {
    // e.preventDefault();
    if ($(e.target).hasClass('hamburger-icon')) {
      $('.sidebar').addClass('sidebar-is-open');
      $('.sidebar').css({'box-shadow': '5px 0 20px -5px #888'});
      $('.right-sidebar').removeClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': 'none'});
    } else if ($(e.target).hasClass('saved-icon')) {
      $('.sidebar').removeClass('sidebar-is-open');
      $('.sidebar').css({'box-shadow': 'none'});
      $('.right-sidebar').addClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': '5px 0 20px 5px #888'});
    } else if (!$(e.target).hasClass('sidebar') && !$(e.target).parents('.sidebar').length && $('.sidebar').hasClass('sidebar-is-open')) {
      $('.sidebar').css({'box-shadow': 'none'});
      $('.sidebar').removeClass('sidebar-is-open');
    } else if (!$(e.target).hasClass('right-sidebar') && !$(e.target).parents('.right-sidebar').length && $('.right-sidebar').hasClass('right-sidebar-is-open')) {
      $('.right-sidebar').removeClass('right-sidebar-is-open');
      $('.right-sidebar').css({'box-shadow': 'none'});
    }
  });

  $('.unit-panel').on('click', function() {
    window.location.href = $(this).data('url');
  });

  $('.unit-panel').hover(function() {
    $(this).find('.view-text').toggleClass('hidden');
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

  $('.den').on('click', function() {
    var $otherParagraph = (typeof $(this).next('p').html() === 'undefined') ? $(this).prev('p') : $(this).next('p');
    if ($(this).css('font-weight') == 'bold') {
      $(this).css({'font-weight': 'normal'});
    } else if ($otherParagraph.css('font-weight') == 'bold') {
      $otherParagraph.css({'font-weight': 'normal'});
      $(this).css({'font-weight': 'bold'});
    } else {
      $(this).css({'font-weight': 'bold'});
    }
    $("input[name='den']").val($(this).data('included'));
  });

  $('.balcony').on('click', function() {
    var $otherParagraph = (typeof $(this).next('p').html() === 'undefined') ? $(this).prev('p') : $(this).next('p');
    if ($(this).css('font-weight') == 'bold') {
      $(this).css({'font-weight': 'normal'});
    } else if ($otherParagraph.css('font-weight') == 'bold') {
      $otherParagraph.css({'font-weight': 'normal'});
      $(this).css({'font-weight': 'bold'});
    } else {
      $(this).css({'font-weight': 'bold'});
    }
    $("input[name='balcony']").val($(this).data('included'))
  });

  $('.bathroom').on('click', function() {
    var $otherParagraph = (typeof $(this).next('p').html() === 'undefined') ? $(this).prev('p') : $(this).next('p');
    if ($(this).css('font-weight') == 'bold') {
      $(this).css({'font-weight': 'normal'});
    } else if ($otherParagraph.css('font-weight') == 'bold') {
      $otherParagraph.css({'font-weight': 'normal'});
      $(this).css({'font-weight': 'bold'});
    } else {
      $(this).css({'font-weight': 'bold'});
    }
    $("input[name='number_of_bathrooms']").val($(this).data('number-of-bathrooms'))
  });

  $(".countdown").countdown("2017/05/01", function(event) {
    var $this = $(this).html(event.strftime(''
    + '<span>%d</span>d '
    + '<span>%H</span>h '
    + '<span>%M</span>m '
    + '<span>%S</span>s'));
  });

  $('.filters').on('click', function() {
    if($(".filters-container").css('top') == '-350px'){
      $(".filters-container").animate({ top:'113px' }, 300);
      showMask();
    }
  });

  $('.btn-accept, .btn-decline').on('click', function(e) {
    e.preventDefault();
    if($(".filters-container").css('top') == '113px'){
      $(".filters-container").animate({ top:'-350px' }, 300);
      hideMask();
    }

    if ($(this).hasClass('btn-accept')) {
      var sendingData = false;
      var url = $(this).data('url');

      if (!sendingData) {
        sendingData = true;

        $.ajax({
          url: url,
          type: 'POST',
          dataType: 'SCRIPT',
          data: { balcony: $("input[name='balcony']").val(), den: $("input[name='den']").val(), number_of_bathrooms: $("input[name='number_of_bathrooms']").val()},
          beforeSend: function() {
            $('.tab-pane.active#one-bed, .tab-pane.active#two-bed, .tab-pane.active#three-bed').html("<div class='dot-animation-two'><div class='circleone'></div><div class='circletwo'></div><div class='circlethree'></div></div>");
          }
        })
        .done(function(data) {
        })
        .fail(function(jqXHR, textStatus, errorThrown) {
        })
        .always(function() {
          sendingData = false;
        });
      }
    }
  });

  function showMask() {
    $('.mask').css({'display': 'block'});
  }

  function hideMask() {
    $('.mask').css({'display': 'none'});
  }

  var handlesSlider = document.getElementById('slider-handles');
  noUiSlider.create(handlesSlider, {
    start: 127,
    connect: [true, false],
    range: {
      'min': 0,
      'max': 255
    }
  });

  handlesSlider.noUiSlider.on('change', function(e){
    debugger;
  })
});
