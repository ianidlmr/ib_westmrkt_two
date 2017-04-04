$(function() {
  var sendingData = false;

  // ------------------------------------------------------------------------------
  // Generic Functions
  function like($savedContainer) {
    var url = $savedContainer.data('url');

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

  $('body').on('click', '.saved-container', function(e) {
    e.preventDefault();
    like($(this));
  });

  $('body').on('click', '.close-icon', function(e) {
    e.preventDefault();
    unlike($(this));
  });
});