var accountsHandler = (function(){

  // Module Functions
  var initialize = function() {
    initAutoNumeric();
    updateToBudgetWithOnBucketBalanceChange();
  };

  var initAutoNumeric = function() {
    new AutoNumeric.multiple('.currency-input', {modifyValueOnWheel: false, minimumValue: '0'});
  }

  var updateToBudgetWithOnBucketBalanceChange = function() {
    var $balanceInput = $('.currency-input');
    $balanceInput.on('input', function() {
      var inputVal = $(this).val();

      // Skip sending updates if decimal input is last or else validation errors from server
      if (inputVal.indexOf('.') == inputVal.length - 1) {
        return;
      }
      var accountId = $('#account_id').val();
      var bucketId = $(this).attr('bucket_id')
      // Remove commas so validation errors don't occur
      var formattedInputVal = inputVal.replace(',', '');

      $.ajax({
        url: '/accounts/'+accountId+'/buckets/'+bucketId+'/balance',
        data: {bucket: {current_balance: formattedInputVal}},
        type: 'PATCH'
      });
    })
  };

  return {
    init: initialize
  };
})();

$(document).on('turbolinks:load', function() {
  accountsHandler.init();
});
