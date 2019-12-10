var accountsHandler = (function(){

  // Module Functions
  var initialize = function() {
    initAutoNumeric();
    updateToBudgetWithOnBucketBalanceChange();
  };

  var initAutoNumeric = function() {
    new AutoNumeric.multiple('.currency-input', {modifyValueOnWheel: false, minimumValue: '0', digitGroupSeparator: ''});
  }

  var updateToBudgetWithOnBucketBalanceChange = function() {
    var $balanceInput = $('.currency-input');
    $balanceInput.on('input', function() {
      var inputVal = $(this).val();
      var accountId = $('#account_id').val();
      var bucketId = $(this).attr('bucket_id')

      $.ajax({
        url: "/accounts/"+accountId+"/buckets/"+bucketId+"/balance",
        data: {bucket: {current_balance: inputVal}},
        type: "PATCH"
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