// Generated by CoffeeScript 1.3.3
(function() {

  window.morpheus = {
    getDataForUser: function(username, earliestDate, latestDate, callback) {
      if (earliestDate == null) {
        earliestDate = null;
      }
      if (latestDate == null) {
        latestDate = null;
      }
      if ((typeof startTime !== "undefined" && startTime !== null) && (typeof endTime !== "undefined" && endTime !== null)) {
        return $.getJSON('/data/?username=' + username + '&' + 'earliestdate=' + earliestDate + '&' + 'latestdate=' + latestDate, callback);
      } else {
        return $.getJSON('/data/?username=' + username, callback);
      }
    }
  };

  'putSleepForUser : (username, start, end, callback) ->\n    $.post(\'/data/?\')\n    #Headers\n    #Username\n    #Start\n    #End\n\n    if startTime? and endTime?\n        $.getJSON \'/data/?username=\'+username\n            +\'&\'+\'earliestdate=\'+earliestDate\n            +\'&\'+\'latestdate=\'+latestDate, callback\n    else\n        $.getJSON \'/data/?username=\'+username, callback';


}).call(this);