$(function() {
  if ($('body.units.show').length) {
    openSavedUnit();

    $('.wrapper').scroll(function() {

      if ($(window).width() >= 768) {
        if($('#floating-box').offset().top + $('#floating-box').height() >= $('footer').offset().top - 10) {
          $('#floating-box').css({'top': '0'});
        }

        if($('.wrapper').scrollTop() + window.innerHeight < $('footer').offset().top) {
          $('#floating-box').css({'top': '20px'}); // restore when you scroll up
        }
      }
    });

    if ($(window).width() >= 768) {
      var offset = ($(window).width() - $('.container').outerWidth()) / 2;
      $('#floating-box').css({'right': offset + 'px'});
    }

    $('.selectize').selectize({
      create: true,
      sortField: 'text',
      onChange: function(unitData) {
        window.location = JSON.parse(unitData).url;
      },
      hideSelected: true,
      render: {
        option: function(data, escape) {
          var unitData = JSON.parse(data.text);
          return '<div class="option">' +
                  '<span class="unit-number">Unit ' + escape(unitData.number) + '</span>' +
                  '<span class="unit-price">$' + escape(unitData.price) + '</span>' +
                  '<span class="unit-orientation">&#8593; ' + escape(unitData.orientation) + '</span>' +
                  '<span class="space"></span>' +
                '</div>';
        },
        item: function(data, escape) {
          var unitData = JSON.parse(data.text);
          return '<div class="item">' +
                  '<span class="unit-number">Unit ' + escape(unitData.number) + '</span>' +
                  '<span class="unit-price">$' + escape(unitData.price) + '</span>' +
                  '<span class="unit-orientation">&#8593; ' + escape(unitData.orientation) + '</span>' +
                  '<span class="space"></span>' +
                '</div>';
        },
      }
    });

    $('.view-carousel').slick({
      dots: true,
      infinite: true,
      speed: 300,
      slidesToShow: 1,
      adaptiveHeight: true
    });

    $('.parking-tip').tooltip({
      trigger: 'hover',
      placement: 'top'
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
      $option.children('.btn-checkout-container, .close-icon').removeClass('hidden');
      $option.children('.people-saved').css({'color': 'black'});
      $option.css({'background': '#f5f5f5'});
    }
  });
}
