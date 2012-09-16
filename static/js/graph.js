// Generated by CoffeeScript 1.3.3
(function() {
  var InteractionState, Sleep, TempBar, User, chartC, chartO, createUserBar, csrfSafeMethod, currentInteractionState, dateFromX, formatTime, getCookie, globalChartCOffset, mainUser, position, randint, refreshUserBar, resizeChart, resizeLines, ticks, timeFromY, updateCurrent, updateOverview, xPosition;

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

  TempBar = (function() {

    function TempBar(parent, x, y, width, height) {
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
    }

    return TempBar;

  })();

  mainUser = new User('Gomez');

  chartO = d3.select("#overview-chart");

  chartC = d3.select("#current-chart");

  globalChartCOffset = {
    top: 50
  };

  InteractionState = (function() {

    function InteractionState() {
      this.isMakingBar = false;
      this.isDragging = 0;
    }

    InteractionState.prototype.setRange = function(earliestDate, latestDate) {
      this.earliestDate = earliestDate;
      this.latestDate = latestDate;
    };

    InteractionState.prototype.setOverviewRange = function(earliestOverviewDate, latestOverviewDate) {
      this.earliestOverviewDate = earliestOverviewDate;
      this.latestOverviewDate = latestOverviewDate;
    };

    InteractionState.prototype.daysInRange = function() {
      return Math.ceil((this.earliestDate - this.latestDate) / 1000 / 60 / 60 / 24);
    };

    InteractionState.prototype.daysInOverviewRange = function() {
      return Math.ceil((this.earliestOverviewDate - this.latestOverviewDate) / 1000 / 60 / 60 / 24);
    };

    InteractionState.prototype.currentBar = [];

    return InteractionState;

  })();

  currentInteractionState = new InteractionState();

  formatTime = function(d) {
    var amPm, hours, mins;
    hours = d.getHours(d);
    mins = d.getMinutes(d) + '';
    amPm = ' am';
    if (hours > 11) {
      hours -= 12;
      amPm = ' pm';
    }
    if (hours === 0) {
      amPm = ' am';
      hours = 12;
    }
    if (mins.length === 1) {
      mins = '0' + mins;
    }
    return hours + ':' + mins + amPm;
  };

  updateOverview = function() {
    chartO.selectAll(".bar").data(mainUser.sleeps).enter().append("rect").attr("class", "bar");
    return resizeChart(chartO, '#overview-chart', currentInteractionState.earliestOverviewDate, currentInteractionState.latestOverviewDate);
  };

  updateCurrent = function() {
    var h, the_ticks, tick_count, tw;
    tick_count = 8;
    the_ticks = ticks(tick_count);
    h = $('#current-chart').height() - globalChartCOffset.top;
    tw = $('#current-chart').width();
    chartC.selectAll(".bar").data(mainUser.sleeps.slice(-currentInteractionState.daysInRange())).enter().append("rect").attr("class", "bar");
    chartC.selectAll("line").data(the_ticks).enter().append("line").attr("y1", function(d) {
      return position(d) * h;
    }).attr("y2", function(d) {
      return position(d) * h;
    }).attr("x1", 0).attr("x2", tw).style("stroke", "rgba(100,100,100,0.3)");
    chartC.selectAll(".rule").data(the_ticks).enter().append("text").attr("class", "rule").attr("y", function(d) {
      return position(d) * h;
    }).attr("x", 0).attr("dx", 20).text(function(d) {
      return formatTime(d);
    }).attr("text-anchor", "middle");
    return resizeChart(chartC, '#current-chart', currentInteractionState.earliestDate, currentInteractionState.latestDate, 10);
  };

  createUserBar = function() {
    chartC.selectAll(".userbar").data(currentInteractionState.currentBar).enter().append("rect").attr("class", "userbar");
    return refreshUserBar();
  };

  refreshUserBar = function() {
    return chartC.selectAll(".userbar").transition().duration(0).attr("x", function(d) {
      return d.x;
    }).attr("y", function(d) {
      return d.y;
    }).attr("width", function(d) {
      return d.width;
    }).attr("height", function(d) {
      return d.height;
    });
  };

  resizeChart = function(chart, idStr, dmin, dmax, spacing) {
    var elementCount, h, state, tw, w;
    if (spacing == null) {
      spacing = 1;
    }
    state = new InteractionState();
    state.setRange(dmin, dmax);
    elementCount = state.daysInRange();
    console.log(elementCount);
    h = $(idStr).height() - globalChartCOffset.top;
    tw = $(idStr).width();
    w = tw / (elementCount + spacing / 2);
    if (w < 5) {
      w = 5;
    }
    return chart.selectAll(".bar").transition().duration(0).attr("height", function(d, i) {
      return (position(d.end) - position(d.start)) * h;
    }).attr("width", function(d, i) {
      return w;
    }).attr("x", function(d, i) {
      return xPosition(d.start, 0, $(idStr).width(), state.earliestDate, state.latestDate);
    }).attr("y", function(d, i) {
      return position(d.start) * h + globalChartCOffset.top;
    });
  };

  xPosition = function(d, pmin, pmax, dmin, dmax) {
    d = d.valueOf() / (1000 * 60 * 60 * 24);
    dmin = dmin.valueOf() / (1000 * 60 * 60 * 24);
    dmax = dmax.valueOf() / (1000 * 60 * 60 * 24);
    return Math.floor(d - dmin) / (dmax - dmin) * pmax;
  };

  resizeLines = function() {
    var h, tw;
    h = $('#current-chart').height() - globalChartCOffset.top;
    tw = $('#current-chart').width();
    chartC.selectAll("line").transition(0).duration(0).attr("y1", function(d) {
      return position(d) * h + globalChartCOffset.top;
    }).attr("y2", function(d) {
      return position(d) * h + globalChartCOffset.top;
    }).attr("x1", 0).attr("x2", tw);
    return chartC.selectAll(".rule").transition(0).duration(0).attr("y", function(d) {
      return position(d) * h + globalChartCOffset.top;
    }).attr("x", 0).attr("dx", 35);
  };

  position = function(d) {
    return ((d.getHours() + d.getMinutes() / 60 + d.getSeconds() / (60 * 60)) / 24 + 0.25) % 1;
  };

  window.position = position;

  ticks = function(n) {
    var count, hours, i, minutes, seconds, tick, _i, _j, _len, _ref, _results;
    ticks = [];
    count = (function() {
      _results = [];
      for (var _i = 0; 0 <= n ? _i <= n : _i >= n; 0 <= n ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this);
    for (_j = 0, _len = count.length; _j < _len; _j++) {
      i = count[_j];
      tick = 1 / n * i;
      _ref = timeFromY(tick), hours = _ref[0], minutes = _ref[1], seconds = _ref[2];
      ticks.push(new Date(2012, 1, 1, hours, minutes, seconds));
    }
    return ticks;
  };

  timeFromY = function(y) {
    var hours, minute_fraction, minutes, second_fraction, seconds;
    y = (y - 0.25) % 1;
    if (y < 0) {
      y += 1;
    }
    hours = y * 24;
    minute_fraction = hours % 1;
    minutes = minute_fraction * 60;
    second_fraction = minute_fraction % 1;
    seconds = second_fraction * 60;
    return [hours, minutes, seconds];
  };

  dateFromX = function(x, dmin, dmax, xmax) {
    var d;
    dmin = dmin.valueOf() / (1000 * 60 * 60 * 24);
    dmax = dmax.valueOf() / (1000 * 60 * 60 * 24);
    d = new Date(Math.floor(dmin + x * (dmax - dmin) / xmax) * (1000 * 60 * 60 * 24));
    return d;
  };

  $('#current-chart').mousemove(function(e) {
    var d, h, hours, minutes, seconds, x, y, _ref;
    h = $('#current-chart').height() - globalChartCOffset.top;
    x = e.pageX - this.offsetLeft;
    y = e.pageY - this.offsetTop - globalChartCOffset.top;
    _ref = timeFromY(y / h), hours = _ref[0], minutes = _ref[1], seconds = _ref[2];
    d = new Date(2012, 1, 1, hours, minutes, seconds);
    return console.log(dateFromX(x, currentInteractionState.earliestDate, currentInteractionState.latestDate, $('#current-chart').width()));
  });

  $('#current-chart').click(function(e) {
    var temp;
    temp = new TempBar($('#current-chart'), 0, 0, 200, 200);
    currentInteractionState.currentBar.push(temp);
    return createUserBar();
  });

  window.morpheus.getDataForUser((function(response) {
    var newSleep, s, _i, _len;
    for (_i = 0, _len = response.length; _i < _len; _i++) {
      s = response[_i];
      newSleep = new Sleep(s.start, s.end);
      mainUser.sleeps.push(newSleep);
    }
    console.log("earliest " + mainUser.sleeps.slice(-8)[0].start);
    console.log("latest " + mainUser.sleeps.slice(-1)[0].end);
    currentInteractionState.setRange(mainUser.sleeps.slice(-8)[0].start, mainUser.sleeps.slice(-1)[0].end);
    currentInteractionState.setOverviewRange(mainUser.sleeps[0].start, mainUser.sleeps.slice(-1)[0].end);
    updateOverview();
    updateCurrent();
    return resizeLines();
  }), 'Gomez');

  $(window).resize(function() {
    resizeChart(chartO, '#overview-chart', currentInteractionState.earliestOverviewDate, currentInteractionState.latestOverviewDate);
    resizeChart(chartC, '#current-chart', currentInteractionState.earliestDate, currentInteractionState.latestDate, 10);
    return resizeLines();
  });

  getCookie = function(name) {
    var cookie, cookieValue, cookies, _i, _len;
    cookieValue = null;
    if (document.cookie && document.cookie !== '') {
      cookies = document.cookie.split(';');
      for (_i = 0, _len = cookies.length; _i < _len; _i++) {
        cookie = cookies[_i];
        cookie = jQuery.trim(cookie);
        if (cookie.substring(0, name.length + 1) === (name + '=')) {
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;
        }
      }
    }
    return cookieValue;
  };

  csrfSafeMethod = function(method) {
    return /^(GET|HEAD|OPTIONS|TRACE)$/.test(method);
  };

  $.ajaxSetup({
    crossDomain: false,
    beforeSend: function(xhr, settings) {
      if (!csrfSafeMethod(settings.type)) {
        return xhr.setRequestHeader("X-CSRFToken", getCookie('csrftoken'));
      }
    }
  });

}).call(this);
