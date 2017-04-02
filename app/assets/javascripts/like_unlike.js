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
        // ajaxToastrError(jqXHR);
      })
      .always(function() {

        sendingData = false;
      });
    }
  }

  // function unlike(btnLike, btnUnlike) {
  //   var url = btnUnlike.data('url');
  //   var not_signed_in = btnUnlike.data('not-signed-in');

  //   if (not_signed_in == true) {
  //     window.location = url;
  //     return;
  //   }

  //   if (!sendingData && url.length) {
  //     sendingData = true;

  //     $.ajax({
  //       url: url,
  //       type: 'PUT',
  //       dataType: 'JSON'
  //     })
  //     .done(function(data) {
  //       if (data.success) {
  //         btnUnlike.fadeOut('fast', function(){
  //           btnLike.fadeIn('fast', null);
  //         });
  //       } else {
  //         toastrError(data.message);
  //       }
  //     })
  //     .fail(function(jqXHR, textStatus, errorThrown) {
  //       ajaxToastrError(jqXHR);
  //     })
  //     .always(function() {
  //       btnUnlike.attr('disabled', false);
  //       sendingData = false;
  //     });
  //   }
  // }

  $('body').on('click', '.saved-container', function(e) {
    e.preventDefault();
    like($(this));
  });
});