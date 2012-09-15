// Generated by CoffeeScript 1.3.3
(function() {
  var Sleep, User, chartC, chartO, eTime, i, mainUser, randint, s, sTime, _i;

  randint = function(a, b) {
    return Math.floor(Math.random() * (b - 1) + a);
  };

  Sleep = (function() {

    function Sleep(user, start, end) {
      this.user = user;
      this.start = start;
      this.end = end;
    }

    return Sleep;

  })();

  User = (function() {

    function User(name) {
      this.name = name;
      this.sleeps = [];
    }

    return User;

  })();

  mainUser = new User('Test');

  for (i = _i = 1; _i <= 200; i = ++_i) {
    sTime = randint(0, 5);
    eTime = sTime + randint(3, 9);
    s = new Sleep(mainUser, sTime, eTime);
    mainUser.sleeps.push(s);
  }

  chartO = d3.select("#overview-chart");

  chartC = d3.select("#current-chart");

  chartO.selectAll("rect").data(mainUser.sleeps).enter().append("rect").attr("x", function(d, i) {
    return i * 20;
  }).attr("y", function(d, i) {
    var overviewIntervals;
    overviewIntervals = $('#overview-wrapper').height() / 100.0;
    return d.start * overviewIntervals;
  }).attr("height", function(d, i) {
    var overviewIntervals;
    overviewIntervals = $('#overview-wrapper').height() / 100.0;
    return (d.end - d.start) * overviewIntervals;
  }).attr("width", 20);

  chartC.selectAll("rect").data(mainUser.sleeps.slice(-7)).enter().append("rect").attr("x", function(d, i) {
    return i * 20;
  }).attr("y", function(d, i) {
    return d.start * 10;
  }).attr("height", function(d, i) {
    return (d.end - d.start) * 10;
  }).attr("width", 20);

}).call(this);