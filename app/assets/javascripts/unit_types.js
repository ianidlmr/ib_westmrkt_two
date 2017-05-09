$(function() {
  if ($('body.unit-types.index').length) {
    if (sessionStorage.getItem('queryString')) {
      var sendingData = false;
      var dataObject = JSON.parse(sessionStorage.getItem('dataObject'));
      var queryString = sessionStorage.getItem('queryString');
      window.history.pushState(null, document.title, '?' + queryString);

      if (!sendingData) {
        sendingData = true;

        $.ajax({
          url: '/unit-types',
          type: 'GET',
          dataType: 'SCRIPT',
          data: dataObject,
          beforeSend: function() {
            $('.tab-pane#zero-bed, .tab-pane#one-bed, .tab-pane#two-bed, .tab-pane#three-bed').html("<div class='dot-animation-two'><div class='circleone'></div><div class='circletwo'></div><div class='circlethree'></div></div>");
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

    Object.keys(searchParams).forEach(function(key) {
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
      $('li.filters a span').show();
      $('li.filters a').css({'font-weight': 'bold'});
      $("input[name='" + key.trim().replace(/-/g, '_') + "']").val($(this).data('value'));
      updateOptionValueUI(key, $(this).data('value'));
    });

    $('.filters').on('click', function(e) {
      e.preventDefault();
      if($(".filters-container").css('top') == '-350px') {
        $(".filters-container").animate({ top: '113px' }, 300);
        showMask();
      }

      if($(".filters-container").css('top') == '-490px') {
        $(".filters-container").animate({ top: '101px' }, 300);
        showMask();
      }
    });

    $('body').on('click', '.btn-accept, .btn-clear', function(e) {
      e.preventDefault();
      if($(".filters-container").css('top') == '113px'){
        $(".filters-container").animate({ top:'-350px' }, 300);
        hideMask();
      }

      if($(".filters-container").css('top') == '101px'){
        $(".filters-container").animate({ top:'-490px' }, 300);
        hideMask();
      }

      if ($(this).hasClass('btn-accept')) {
        var sendingData = false;
        var priceSlider = document.getElementById('price-average');
        var priceVal = parseFloat(priceSlider.noUiSlider.get().match(/[\d\.]+/g)[0]);
        var price = priceVal < 100 ? priceVal * 1000000 : priceVal * 1000;
        var dataObject = { balcony: $("input[name='balcony']").val(), den: $("input[name='den']").val(), number_of_bathrooms: $("input[name='number_of_bathrooms']").val(), price: price.toString() };

        if (!sendingData) {
          sendingData = true;

          $.ajax({
            url: '/unit-types',
            type: 'GET',
            dataType: 'SCRIPT',
            data: dataObject,
            beforeSend: function() {
              $('.tab-pane#zero-bed, .tab-pane#one-bed, .tab-pane#two-bed, .tab-pane#three-bed').html("<div class='dot-animation-two'><div class='circleone'></div><div class='circletwo'></div><div class='circlethree'></div></div>");

              var queryString = Object.keys(dataObject).map(function(key) {
                return key + "=" + dataObject[key];
              }).join('&');
              window.history.pushState(null, document.title, '?' + queryString);
              sessionStorage.setItem('dataObject', JSON.stringify(dataObject));
              sessionStorage.setItem('queryString', queryString);
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
      $('li.filters a span').hide();
      $('li.filters a').css({'font-weight': 'normal'});
    });
  }
});