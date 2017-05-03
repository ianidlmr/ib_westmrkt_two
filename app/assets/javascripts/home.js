$(function() {
  if ($('body.home.about').length) {
    $('.about-carousel').slick({
      dots: true,
      infinite: true,
      speed: 1000,
      slidesToShow: 1,
      arrows: false
    });

    $('.about-carousel').slick('slickPlay');
    setInterval(function(){
      $(".slick-next").click();
    },6000);
  }

  if ($('body.home.index').length) {
    $('.selectize').selectize({
      create: true,
      sortField: 'text'
    });
  }
});