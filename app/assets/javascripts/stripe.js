$(function() {
  if ($('body.orders-steps.show').length && typeof Stripe !== 'undefined') {
    var success = false;
    var stripe = Stripe('pk_test_eIAHlZIBEwVVMGXp7OaNuSsE');

    // Create an instance of Elements
    var elements = stripe.elements();

    // Custom styling can be passed to options when creating an Element.
    var style = {
      base: {
        color: '#32325d',
        lineHeight: '24px',
        fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
        fontSmoothing: 'antialiased',
        fontSize: '16px',
        '::placeholder': {
          color: '#aab7c4'
        }
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a'
      }
    };

    // Create an instance of the card Element
    var card = elements.create('card', {style: style, hidePostalCode: true});

    // Add an instance of the card Element into the `card-element` <div>
    card.mount('#card-element');

    // Handle real-time validation errors from the card Element.
    card.addEventListener('change', function(event) {
      var displayError = document.getElementById('card-errors');
      if (event.error) {
        displayError.textContent = event.error.message;
      } else {
        displayError.textContent = '';
      }
    });

    // Handle form submission
    var $form = $('.simple_form.edit_order');
    $form.on('submit', function(event) {
      if (!success && $form.valid()) {
        event.preventDefault();
        event.stopPropagation();
        $form.find('[type=submit]').prop('disabled', true);

        stripe.createToken(card).then(function(result) {
          if (result.error) {
            // Inform the user if there was an error
            var errorElement = $('#card-errors');
            errorElement.show();
            errorElement.text = result.error.message;
            $form.find('[type=submit]').prop('disabled', false);
            return false;
          } else {
            $form.find('[type=submit]').prop('value', 'Processing card');
            stripeTokenHandler(result.token);
          }
        });
      }
    });

    function stripeTokenHandler(token) {
      $.ajax({
        url: '/users/stripe/add_card_to_stripe',
        type: 'PUT',
        data: {token: token},
        dataType: 'JSON',

        success: function(data) {
          success = true;
          $form.submit();
        },

        error: function(jqXHR, textStatus, errorThrown) {
          var errorElement = $('#card-errors');
          errorElement.show();
          $form.find('[type=submit]').prop('value', 'Try again');
          $form.find('[type=submit]').prop('disabled', false)

          // Show Stripe errors on the form
          if (jqXHR.responseText.length) {
            $form.find('#card-errors').text(jqXHR.responseText);
          } else {
            $form.find('#card-errors').text('Try refreshing the page and trying again.');
          }
        }
      });
    }

    // stripe_iframe = all('iframe[name=stripe_checkout_app]').last
    // Capybara.within_frame stripe_iframe do
    //   page.execute_script(%Q{ $('input#card_number').val('4242 4242 4242 4242'); })
    //   page.execute_script(%Q{ $('input#cc-exp').val('12/16'); })
    //   #rest of the Stripe-capybara
    // end
  }
});
