$(function() {
  if ($('body.units.index').length) {

    function updateOptionValueUI(key, value) {
      var $options = $('.filters-container').find('.' + key);

      $options.each(function (i, node) {
        var $option = $(node);
        if ($option.data('value') === value && !$option.hasClass('bold')) {
          $option.addClass('bold');
        } else {
          $option.removeClass('bold');
        }
      });
    }

    $('.unit-panel').on('click', function() {
      window.location.href = $(this).data('url');
    });

    $('.den, .balcony, .number-of-bathrooms').on('click', function() {
      var key = this.className;
      $("input[name='" + key.trim().replace(/-/g, '_') + "']").val($(this).data('value'));
      updateOptionValueUI(key, $(this).data('value'));
    });

    $('.filters').on('click', function() {
      if($(".filters-container").css('top') == '-350px') {
        $(".filters-container").animate({ top: '113px' }, 300);
        showMask();
      }

      if($(".filters-container").css('bottom') == '-350px') {
        $(".filters-container").animate({ bottom: '0px' }, 300);
        showMask();
      }
    });

    $('.btn-accept, .btn-decline').on('click', function(e) {
      e.preventDefault();
      if($(".filters-container").css('top') == '113px'){
        $(".filters-container").animate({ top:'-350px' }, 300);
        hideMask();
      }

      if($(".filters-container").css('bottom') == '0px'){
        $(".filters-container").animate({ bottom: '-350px' }, 300);
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
              $('.tab-pane#one-bed, .tab-pane#two-bed, .tab-pane#three-bed').html("<div class='dot-animation-two'><div class='circleone'></div><div class='circletwo'></div><div class='circlethree'></div></div>");
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
  }
});