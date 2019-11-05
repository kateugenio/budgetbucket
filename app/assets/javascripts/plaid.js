var PlaidService = (function() {

  // Constants
  var LINK_BUTTON = 'a#connect-external-bank';

  // Module Vars
  var $linkButton;

  // Module Functions
  var initialize = function() {
    initPlaidConnectWidget();
  };

  // Private Methods
  var initPlaidConnectWidget = function () {
    $linkButton = $(LINK_BUTTON);

    var handler = Plaid.create({
      clientName: 'Plaid Quickstart',
      // Optional, specify an array of ISO-3166-1 alpha-2 country
      // codes to initialize Link; European countries will have GDPR
      // consent panel
      countryCodes: ['US'],
      env: 'sandbox',
      // Replace with your public_key from the Dashboard
      key: 'd26c1c4c1c41b04dd2540ef36d05b2',
      product: ['assets'],
      // Optional, specify a language to localize Link
      language: 'en',
      onLoad: function() {
        // Optional, called when Link loads
        console.log("In onLoad")
      },
      onSuccess: function(public_token, metadata) {
        // Send the public_token to your app server.
        // The metadata object contains info about the institution the
        // user selected and the account ID or IDs, if the
        // Select Account view is enabled.
        // $.post('/get_access_token', {
        //   public_token: public_token,
        // });
        console.log("In onSuccess and public_token is " + public_token + "and metadata is " + JSON.stringify(metadata));
      },
      onExit: function(err, metadata) {
        console.log("In onExit");
        // The user exited the Link flow.
        if (err != null) {
          // The user encountered a Plaid API error prior to exiting.
        }
        // metadata contains information about the institution
        // that the user selected and the most recent API request IDs.
        // Storing this information can be helpful for support.
      },
      onEvent: function(eventName, metadata) {
        console.log("In onEvent");
        // Optionally capture Link flow events, streamed through
        // this callback as your users connect an Item to Plaid.
        // For example:
        // eventName = "TRANSITION_VIEW"
        // metadata  = {
        //   link_session_id: "123-abc",
        //   mfa_type:        "questions",
        //   timestamp:       "2017-09-14T14:42:19.350Z",
        //   view_name:       "MFA",
        // }
      }
    });

    $linkButton.on('click', function(e) {
      handler.open();
    });
  }

  // Module Public API
  return {
    init: initialize
  }
})();

$(document).on('turbolinks:load', function(){
  PlaidService.init();
});