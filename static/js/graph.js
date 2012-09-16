// Generated by CoffeeScript 1.3.3
(function() {
  var Sleep, User, chartC, chartO, mainUser, randint, resizeChart, updateCurrent, updateOverview;

  randint = function(a, b) {
    return Math.floor(Math.random() * (b - 1) + a);
  };

  User = (function() {

    function User(name) {
      this.name = name;
      this.sleeps = [];
    }

    return User;

  })();

  Sleep = (function() {

    function Sleep(start, end) {
      this.start = start;
      this.end = end;
      this.start = new Date(this.start);
      this.end = new Date(this.end);
    }

    return Sleep;

  })();

  mainUser = new User('Gomez');

  chartO = d3.select("#overview-chart");

  chartC = d3.select("#current-chart");

  updateOverview = function() {
    var h;
    h = $('#overview-chart').height();
    return chartO.selectAll("rect").data(mainUser.sleeps).enter().append("rect").attr("x", function(d, i) {
      return i * 6;
    }).attr("y", function(d, i) {
      return d.start.getHours() * 10;
    }).attr("height", function(d, i) {
      return (d.end.getHours() - d.start.getHours()) * h / 25.0;
    }).attr("width", 5);
  };

  updateCurrent = function() {
    var h;
    h = $('#current-chart').height();
    return chartC.selectAll("rect").data(mainUser.sleeps.slice(-7)).enter().append("rect").attr("y", function(d, i) {
      return d.start.getHours();
    }).attr("height", function(d, i) {
      return (d.end.getHours() - d.start.getHours()) * h / 25.0;
    }).attr("width", function(d, i) {
      return 60;
    }).attr("x", function(d, i) {
      return i * 62;
    });
  };

  resizeChart = function(idStr) {
    var h, l, tw, w;
    h = $(idStr).height();
    tw = $(idStr).width();
    l = mainUser.sleeps.length;
    w = (tw - 10) / l;
    if (w < 5) {
      w = 5;
    }
    return chartO.selectAll("rect").transition().duration(0).attr("height", function(d, i) {
      return (d.end.getHours() - d.start.getHours()) * h / 25.0;
    }).attr("width", function(d, i) {
      return w;
    }).attr("x", function(d, i) {
      return (i * (w + 1)) + (tw - (w + 1) * l);
    });
  };

  window.morpheus.getDataForUser((function(response) {
    var newSleep, s, _i, _len;
    for (_i = 0, _len = response.length; _i < _len; _i++) {
      s = response[_i];
      newSleep = new Sleep(s.start, s.end);
      mainUser.sleeps.push(newSleep);
    }
    updateOverview();
    resizeChart('#overview-chart');
    resizeChart('#current-chart');
    return updateCurrent();
  }), 'Gomez');

  $(window).resize(function() {
    return resizeChart('#overview-chart');
  });

}).call(this);
