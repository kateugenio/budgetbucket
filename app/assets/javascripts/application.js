// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require popper
//= require bootstrap-sprockets
//= require assets/js/argon-dashboard
//= require rails-ujs
//= require turbolinks
//= require_tree .


// Global application events
var applicationHandler = (function() {

  // Module Functions
  var initialize = function() {
    displayGrowingSpinnerOnLoadingSpinnerBtn();
  };

  // Private Methods
  var displayGrowingSpinnerOnLoadingSpinnerBtn = function() {
    var loadingTextBefore = $('#loading-text').text();
    // `remote: true` set on link helper, so need to use bind to bind two ajax calls
    $('#loading-spinnter-btn').bind('ajax:beforeSend', function() {
      $(this).attr('disabled', 'disabled');
      $('.spinner-grow').removeClass('d-none');
      $('#loading-text').html('Loading...')
    });

    $('#loading-spinnter-btn').bind('ajax:complete', function() {
      $(this).removeAttr('disabled');
      $('.spinner-grow').addClass('d-none');
      $('#loading-text').html(loadingTextBefore);
    });
  }

  var humanizeDateTimeFields = function() {
    // Not currently used, but may come in handy sooner or later
    $('.momentize-time-ago').each(function(index, element) {
      var momentTimestamp = moment.unix($(element).data('datetime'));
      var now = moment.utc();
      var timeDelta = momentTimestamp.diff(now);
      var humanized = moment.duration(timeDelta).humanize(true);

      $(element).text(humanized);
    });

    $('.momentize-format').each(function(index, element) {
      var sourceDatetime = $(element).data('datetime');
      var sourceDate = $(element).data('date');
      var sourceUnixTime = $(element).data('unixtime');

      // Moment Timezone: http://momentjs.com/timezone/docs/#/using-timezones/guessing-user-timezone/
      var timezone = moment.tz.guess();

      if (sourceDatetime) {
        var momentTimestamp = moment.unix(sourceDatetime);
        // Format: July 9, 2018 12:15 PM PDT
        var humanized = moment.tz(momentTimestamp, timezone).local().format('LLLL z');
      }
      else if (sourceDate) {
        var momentTimestamp = moment.unix(sourceDate);
        var humanized = moment.tz(momentTimestamp, timezone).local().format('MM/DD/YYYY');
      }
      else if (sourceUnixTime) {
        var momentTimestamp = moment.unix(sourceUnixTime);
        var humanized = moment.tz(momentTimestamp, timezone).local().format('h:mm A z');
      }
      else {
        return;
      }
      $(element).text(humanized);
    });
  };

  return {
    init: initialize,
    humanizeDateTimeFields: humanizeDateTimeFields
  };
})();

$(document).on('turbolinks:load', function() {
  applicationHandler.init();
  applicationHandler.humanizeDateTimeFields();
});
