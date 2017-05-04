$(function() {
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

    var epochTime = $(".countdown").data('epoch-time');

    if (typeof epochTime !== 'undefined') {
      $(".countdown").countdown(epochTime, function(event) {
        var $this = $(this).html(event.strftime(''
        + '<span>%D</span>d '
        + '<span>%H</span>h '
        + '<span>%M</span>m '
        + '<span>%S</span>s'));
      });
    }
  }

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

  if ($('body.home.help').length) {
    $('.help-option').click(function() {
      var helpMenuArrow = $(this).children('.help-option svg');
      var helpMenuAnswer = $(this).children('.help-option p');

      if ( $(helpMenuArrow).hasClass('rotate-180') ) {
        $(helpMenuArrow).removeClass('rotate-180');
      } else if ( $(helpMenuArrow).not('rotate-180') )  {
        $(helpMenuArrow).addClass('rotate-180');
      }

      if ( $(helpMenuAnswer).hasClass('help-active') ) {
        $(helpMenuAnswer).removeClass('help-active');
      } else if ( $(helpMenuAnswer).not('help-active') )  {
        $(helpMenuAnswer).addClass('help-active');
      }
    });
  }
});