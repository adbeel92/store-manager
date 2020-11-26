//= require active_admin/base
//= require easy-autocomplete

var autocomplete = function(input) {
  var $hiddenInput, $input;
  $input = $(input);
  $hiddenInput = $('#' + $input.attr('id') + '_input').find(':hidden');

  var options = {
    url: function(query) {
      return $input.data('url') + "?q=" + query;
    },
    getValue: "label",
    requestDelay: 500,
    list: {
      match: {
        enabled: true
      },
      sort: {
        enabled: true
      },
      onChooseEvent: function() {
        var value = $input.getSelectedItemData().id;
        $hiddenInput.val(value).trigger("change");
      }
    }
  };

  $input.easyAutocomplete(options);
}

var batchAutocomplete = function() {
  $('*[data-behavior="autocomplete"]').each(function(index, input) {
    autocomplete(input);
  });
}

var productFieldsAdded = function() {
  $('.has_many_container.purchase_order_products').on('has_many_add:after', function(){
    batchAutocomplete();
  });
}

var purchaseOrdersReady = function() {
  batchAutocomplete();
  productFieldsAdded();
}

document.addEventListener("turbolinks:load", purchaseOrdersReady);
$(document).ready(purchaseOrdersReady);
