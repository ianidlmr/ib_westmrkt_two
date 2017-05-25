
$(function() {
  if ($('body.units.show').length) {
    openSavedUnit();
    $('.selectize').selectize({
      create: true,
      sortField: 'text',
      onChange: function(unitData) {
        window.location = JSON.parse(unitData).url;
      },
      onDropdownOpen: function () {
        $('.selectize-input').prop('disabled',true).off('click');
      },
      render: {
        option: function(data, escape) {
          var unitData = JSON.parse(data.text);
          var className = data.text === this.getValue() ? 'greyed-out' : '';
          var spanHTML = data.text === this.getValue() ? '<span class="space"><i class="fa fa-circle" aria-hidden="true"></i></span>' : '<span class="space"></span>';
          return '<div class="' + className + ' option">' +

                  '<span class="unit-number unit-number-left-aligned">Suite ' + escape(unitData.number) + '</span>' +
                  '<span class="unit-price unit-price-right-aligned">$' + escape(unitData.price) + '</span>' +
                  '<span class="unit-orientation unit-orientation-right-aligned">'+ getOrientationArrow(unitData.orientation)  + escape(unitData.orientation) + '</span>' +
                  spanHTML +
                '</div>';
        },
        item: function(data, escape) {
          var unitData = JSON.parse(data.text);
          return '<div class="item">' +

                  '<span class="unit-number unit-number-left-aligned">Suite ' + escape(unitData.number) + '</span>' +
                  '<span class="unit-price unit-price-right-aligned">$' + escape(unitData.price) + '</span>' +
                  '<span class="unit-orientation unit-orientation-right-aligned white-svg-arrow"> '+ getOrientationArrow(unitData.orientation) + escape(unitData.orientation) + '</span>' +
                  '<span class="space"></span>' +
                '</div>';
        },
      }
    });

    $('#view-carousel').slick({
      dots: true,
      infinite: true,
      speed: 1000,
      slidesToShow: 1,
      arrows: false,
      adaptiveHeight: true
    });

    $('#view-carousel').slick('slickPlay');
    setInterval(function(){
      $(".slick-next").click();
    },6000);

    $('.parking-tip').tooltip({
      trigger: 'hover',
      placement: 'top'
    });

    // Photoswipe Lightbox
    $('.picture').each( function() {
      var $pic = $(this),
      getItems = function() {
        var items = [];
        $pic.find('a').each(function() {
          var $href = $(this).attr('href'),
          $width = document.getElementById('floor-plan-image').naturalWidth,
          $height = document.getElementById('floor-plan-image').naturalHeight;

          var item = {
            src: $href,
            w: $width,
            h: $height
          };

          items.push(item);
        });

        return items;
      }

      var items = getItems();
      var $pswp = $('.pswp')[0];

      $('.zoom-in, .picture').on('click', function(event) {
        event.preventDefault();

        var options = {
          bgOpacity: 0.8,
          showHideOpacity: true
        }

        // Initialize PhotoSwipe
        var lightBox = new PhotoSwipe($pswp, PhotoSwipeUI_Default, items, options);
        lightBox.init();
      });
    });
  }
});

function openSavedUnit() {
  var $savedUnits = $('.saved-units-container').find('.saved-unit');
  var url = window.location.pathname;
  var unitId = url.substring(url.lastIndexOf('/') + 1);

  $savedUnits.each(function (i, node) {
    var $option = $(node);
    if ($option.data('unit-id') == unitId) {
      $option.children('.btn-checkout-container, .delete-icon').removeClass('hidden');
      $option.children('.people-saved').css({'color': 'black'});
      $option.css({'background': '#f5f5f5'});
    }
  });
}
function getOrientationArrow(orientation) {
  switch(orientation) {
    case 'W':
      viewBox="0 0 9.3672 9.6431"
      path = '<path d="M1.5952,5.2891c1.0435.8877,2.9385,2.6748,4.1138,3.7422l-.5757.6118L0,\
      4.87V4.8335L5.1333,0,5.709.624c-1.1875,1.0913-3.0581,2.83-4.1138,3.79h7.772v.8755Z"/>'
      break;
    case 'E':
      viewBox="0 0 9.3672 9.6426"
      path = '<path d="M7.772,4.3535C6.7285,3.4658,4.8335,1.6792,3.6582.6113L4.2339,0,9.3672,\
      4.7734v.0356L4.2339,9.6426,3.6582,9.019C4.8457,7.9277,6.7163,6.1885,7.772,5.229H0V4.3535Z"/>'
      break;
    case 'N':
      viewBox="0 0 9.1631 9.8706"
      path = '<path d="M4.0781,1.6548C3.19,2.6982,1.6675,4.45.6,5.625L0,5.0132,4.5337,0h.0239L9.1631,\
      5.0132,8.54,5.625c-1.0913-1.1875-2.5908-2.9146-3.55-3.97V9.8706H4.0781Z"/>'
      break;
    case 'S':
      viewbox = "0 0 9.1631 9.8706"
      path = '<path d="M5.085,8.2153c.8877-1.0435,2.4106-2.7944,3.4785-3.97l.6.6118L4.6294,\
      9.8706H4.6055L0,4.8574l.6235-.6118c1.0913,1.187,2.5908,2.9146,3.55,3.97V0H5.085Z"/>'
      break;
  }

  svg = '<svg xmlns="http://www.w3.org/2000/svg" width="11.3672" height="11.6426" viewBox='+viewBox+
  '><g id="Layer_2" data-name="Layer 2"><g id="Layer_1-2" data-name="Layer 1">'+path+
  '</g></g></svg>'

  return svg
}
