$(function() {
  var sendingData = false;

  // ------------------------------------------------------------------------------
  // Generic Functions
  function like($savedMessage) {
    var url = $savedMessage.data('url');

    if (!sendingData && url.length) {
      sendingData = true;

      $.ajax({
        url: url,
        type: 'PUT',
        dataType: 'SCRIPT'
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

  function unlike($closeIcon) {
    var url = $closeIcon.data('url');

    if (!sendingData && url.length) {
      sendingData = true;

      $.ajax({
        url: url,
        type: 'PUT',
        dataType: 'SCRIPT'
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

  $('body').on('click', '.saved-message', function(e) {
    e.preventDefault();
    like($(this));
  });

  $('body').on('click', '.delete-icon', function(e) {
    e.preventDefault();
    unlike($(this));
  });
});