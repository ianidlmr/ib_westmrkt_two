$(function() {
  if ($('body.home.about').length) {
    $('.about-carousel').slick({
      dots: true,
      infinite: true,
      speed: 300,
      slidesToShow: 1,
      adaptiveHeight: true
    });
  }

  if ($('body.home.index').length) {
    $('.selectize').selectize({
      create: false,
      sortField: 'text'
    });
  }
});