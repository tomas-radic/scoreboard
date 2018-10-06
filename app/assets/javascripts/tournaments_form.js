// Functions

// Draws X icon on .remove_fields elements
function removeLinkIcons() {
  var removeLinks = $('.remove_fields');
  $(removeLinks).html('');
  $(removeLinks).append('<i class="fa fa-times"></i>');
}


// When document is ready...
$(document).on('turbolinks:load', function() {
  removeLinkIcons();

  // Activate bootstrap tooltips
  $(function () {
    $('[data-toggle="tooltip"]').tooltip();
  });


  // Events

  // Suggest court label when new court-fields are being inserted
  $('#courts').on('cocoon:before-insert', function(e, insertedItem) {
    var calculatedCourtNr = $('#courts').find(".field").length + 1;
    $(insertedItem.find("input")[0]).val(calculatedCourtNr);
  });

  // Draw X icons after new court-field has been inserted
  $('#courts').on('cocoon:after-insert', function(e, insertedItem) {
    removeLinkIcons();
  });
});