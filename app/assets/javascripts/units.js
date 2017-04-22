$(function() {
  if ($('body.units.index').length) {

  }

  if ($('body.units.show').length) {
    openSavedUnit();

    $('.selectize').selectize({
      create: false,
      sortField: 'text',
      onChange: function(unitUrl) {
        window.location = unitUrl;
      }
    });

    $('.view-carousel').slick({
      dots: true,
      infinite: true,
      speed: 300,
      slidesToShow: 1,
      adaptiveHeight: true
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
