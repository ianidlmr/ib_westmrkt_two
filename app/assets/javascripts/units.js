$(function() {
  if ($('body.units.show').length) {
    openSavedUnit();

    $('.selectize').selectize({
      create: true,
      sortField: 'text',
      onChange: function(unitData) {
        window.location = JSON.parse(unitData).url;
      },
      render: {
        option: function(data, escape) {
          debugger;
          var unitData = JSON.parse(data.text);
          var className = data.text === this.getValue() ? 'greyed-out' : '';
          var spanHTML = data.text === this.getValue() ? '<span class="space"><i class="fa fa-circle" aria-hidden="true"></i></span>' : '<span class="space"></span>';
          return '<div class="' + className + ' option">' +
                  '<span class="unit-number">Suite ' + escape(unitData.number) + '</span>' +
                  '<span class="unit-price">$' + escape(unitData.price) + '</span>' +
                  '<span class="unit-orientation">&#8593; ' + escape(unitData.orientation) + '</span>' +
                  spanHTML +
                '</div>';
        },
        item: function(data, escape) {
          var unitData = JSON.parse(data.text);
          return '<div class="item">' +
                  '<span class="unit-number">Suite ' + escape(unitData.number) + '</span>' +
                  '<span class="unit-price">$' + escape(unitData.price) + '</span>' +
                  '<span class="unit-orientation">&#8593; ' + escape(unitData.orientation) + '</span>' +
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
