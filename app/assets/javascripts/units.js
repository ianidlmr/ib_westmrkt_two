$(function() {
  if ($('body.units.index').length) {

    function getParameterByName(name, url) {
      if (!url) {
        url = window.location.href;
      }
      name = name.replace(/[\[\]]/g, "\\$&");
      var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"), results = regex.exec(url);
      if (!results) return null;
      if (!results[2]) return '';
      return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

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

    var searchParams = {
      balcony: getParameterByName('balcony') !== null && getParameterByName('balcony').length > 0  ? JSON.parse(getParameterByName('balcony')) : '',
      den: getParameterByName('den') !== null && getParameterByName('den').length > 0 ? JSON.parse(getParameterByName('den')) : '',
      'number-of-bathrooms': getParameterByName('number_of_bathrooms') !== null && getParameterByName('number_of_bathrooms').length > 0 ? JSON.parse(getParameterByName('number_of_bathrooms')) : '',
      price: getParameterByName('price') !== null && getParameterByName('price').length > 0 ? JSON.parse(getParameterByName('price')) : ''
    };

    Object.keys(searchParams).map(function(key) {
      updateOptionValueUI(key, searchParams[key])
    });

    var priceSlider = document.getElementById('price-average');
    noUiSlider.create(priceSlider, {
      start: $('#price-average').data('highest-price'),
      connect: [true, false],
      tooltips: [true],
      step: 10000,
      format: wNumb({
        thousand: '.',
        encoder: function(val) {
          if (val >= 1000000) {
            return val / 1E5;
          } else {
            return val / 1E3;
          }
        },
        decoder: function(val) {
          if (val >= 1000000) {
            return val * 1E5;
          } else {
            return val * 1E3;
          }
        },
        edit: function(val) {
          var newVal = parseInt(val);
          if (newVal < 100) {
            var decimalVal = newVal / 10;
            return '$' + decimalVal + 'M CAD';
          } else {
            return '$' + val + 'K CAD';
          }
        },
      }),
      range: {
        'min': $('#price-average').data('lowest-price'),
        'max': $('#price-average').data('highest-price')
      }
    });

    priceSlider.noUiSlider.set(searchParams['price']);

    $('body').on('click', '.unit-panel', function() {
      window.location.href = $(this).data('url');
    });

    $('.den, .balcony, .number-of-bathrooms').on('click', function(e) {
      e.preventDefault();
      var key = this.className;
      $("input[name='" + key.trim().replace(/-/g, '_') + "']").val($(this).data('value'));
      updateOptionValueUI(key, $(this).data('value'));
    });

    $('.filters').on('click', function(e) {
      e.preventDefault();
      if($(".filters-container").css('top') == '-350px') {
        $(".filters-container").animate({ top: '113px' }, 300);
        showMask();
      }

      if($(".filters-container").css('bottom') == '-530px') {
        $(".filters-container").animate({ bottom: '0px' }, 300);
        showMask();
      }
    });

    $('body').on('click', '.btn-accept, .btn-clear', function(e) {
      e.preventDefault();
      if($(".filters-container").css('top') == '113px'){
        $(".filters-container").animate({ top:'-350px' }, 300);
        hideMask();
      }

      if($(".filters-container").css('bottom') == '0px'){
        $(".filters-container").animate({ bottom: '-530px' }, 300);
        hideMask();
      }

      if ($(this).hasClass('btn-accept')) {
        var sendingData = false;
        var priceSlider = document.getElementById('price-average');
        var priceVal = parseFloat(priceSlider.noUiSlider.get().match(/[\d\.]+/g)[0]);
        var price = priceVal < 100 ? priceVal * 1000000 : priceVal * 1000;
        var dataObject = { balcony: $("input[name='balcony']").val(), den: $("input[name='den']").val(), number_of_bathrooms: $("input[name='number_of_bathrooms']").val(), price: price};

        if (!sendingData) {
          sendingData = true;

          $.ajax({
            url: '/units',
            type: 'GET',
            dataType: 'SCRIPT',
            data: dataObject,
            beforeSend: function() {
              $('.tab-pane#one-bed, .tab-pane#two-bed, .tab-pane#three-bed').html("<div class='dot-animation-two'><div class='circleone'></div><div class='circletwo'></div><div class='circlethree'></div></div>");
              window.history.pushState(null, document.title, '?' + Object.keys(dataObject).map(function(key) {
                key + "=" + dataObject[key]).join('&')
              });
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

    $('body').on('click', '.btn-black, .btn-clear', function(e) {
      e.preventDefault();
      $('.den, .balcony, .number-of-bathrooms').removeClass('bold');
      $("input[name='balcony']").val('');
      $("input[name='den']").val('');
      $("input[name='number_of_bathrooms']").val('');
      priceSlider.noUiSlider.set($('#price-average').data('highest-price'));
      $('.btn-accept').trigger('click');
    });
  }

  if ($('body.units.show').length) {
    openSavedUnit();
  }
});

function openSavedUnit() {
  var $savedUnits = $('.saved-units-container').find('.saved-unit');
  var url = window.location.pathname;
  var unitId = url.substring(url.lastIndexOf('/') + 1);

  $savedUnits.each(function (i, node) {
    var $option = $(node);
    if ($option.data('unit-id') == unitId) {
      $option.children('.btn-checkout-container, .close-icon').removeClass('hidden');
      $option.children('.people-saved').css({'color': 'black'});
      $option.css({'background': '#f5f5f5'});
    }
  });
}