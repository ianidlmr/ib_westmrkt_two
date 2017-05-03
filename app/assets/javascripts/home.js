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
    Selectize.define('hidden_textfield', function(options) {
      var self = this;
      this.showInput = function() {
        this.$control.css({cursor: 'pointer'});
        this.$control_input.css({opacity: 0, position: 'relative', left: self.rtl ? 10000 : -10000 });
        this.isInputHidden = false;
      };

      this.setup_original = this.setup;

      this.setup = function() {
        self.setup_original();
        this.$control_input.prop("disabled","disabled");
      }
    });

    $('.selectize').selectize({
      create: true,
      sortField: 'text',
      plugins: ['hidden_textfield']
    });
  }
});