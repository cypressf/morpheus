
randint = (a, b) ->
    Math.floor(Math.random()*(b-1)+a)

class User
    constructor: (@name) ->
        @sleeps = []

class Sleep
    constructor: (@start, @end) ->
        @start = new Date(@start)
        @end = new Date(@end)

class TempBar
    constructor : (@parent, @x, @y, @width, @height) ->

mainUser = new User 'Gomez'

chartO = d3.select("#overview-chart")
chartC = d3.select("#current-chart")
globalChartCOffset =
  top : 50

class InteractionState
    constructor : () ->
        @dragState = 0
    setRange : (@earliestDate, @latestDate) ->
    setOverviewRange : (@earliestOverviewDate, @latestOverviewDate) ->
    daysInRange : () ->
        Math.floor((@latestDate-@earliestDate)/1000/60/60/24)
    daysInOverviewRange : () ->
        Math.floor((@earliestOverviewDate-@latestOverviewDate)/1000/60/60/24)
    currentBar: []

currentInteractionState = new InteractionState()
overviewState = new InteractionState()

formatTime = (d) ->
    hours = d.getHours(d)
    mins = d.getMinutes(d)+''
    amPm = ' am'
    if hours > 11
        hours -= 12
        amPm = ' pm'
    if hours == 0
        amPm = ' am'
        hours = 12
    if mins.length == 1
        mins = '0'+mins
    return hours + ':' + mins + amPm

updateOverview = ->
  tw = $('#overview-chart').width()
  chartO.selectAll(".bar").data(mainUser.sleeps).enter().append("rect").attr("class", "bar")
  resizeChart(chartO, '#overview-chart', overviewState)

  # chartC.selectAll("line")
  #   .data(the_ticks)
  #   .enter().append("line")
  #   .attr("x1", (d) -> position(d) * h)
  #   .attr("x2", (d) -> position(d) * h)
  #   .attr("y1", 0)
  #   .attr("y2", tw)
  #   .style("stroke", "rgba(100,100,100,0.3)")
  
  # chartC.selectAll(".rule")
  #   .data(the_ticks)
  #   .enter().append("text")
  #   .attr("class", "rule")
  #   .attr("x", (d) -> xPosition(d) * w)
  #   .attr("y", 0)
  #   .attr("dy", 20)
  #   .text((d) -> )
  #   .attr("text-anchor", "middle")

updateCurrent = ->
    tick_count = 8
    the_ticks = ticks(tick_count)
    h = $('#current-chart').height() - globalChartCOffset.top  
    tw = $('#current-chart').width()
    chartC.selectAll(".bar")
        .data(mainUser.sleeps[-currentInteractionState.daysInRange()..])
        .enter().append("rect").attr("class", "bar")

    chartC.selectAll("line")
      .data(the_ticks)
      .enter().append("line")
      .attr("y1", (d) -> position(d) * h)
      .attr("y2", (d) -> position(d) * h)
      .attr("x1", 0)
      .attr("x2", tw)
      .style("stroke", "rgba(100,100,100,0.3)")
    
    chartC.selectAll(".rule")
      .data(the_ticks)
      .enter().append("text")
      .attr("class", "rule")
      .attr("y", (d) -> position(d) * h)
      .attr("x", 0)
      .attr("dx", 20)
      .text((d) -> formatTime(d))
      .attr("text-anchor", "middle")

    resizeChart(chartC, '#current-chart', currentInteractionState, 10)

createUserBar = ->
    chartC.selectAll(".userbar")
        .data(currentInteractionState.currentBar)
        .enter().append("rect")
        .attr("class", "userbar")

    refreshUserBar()

refreshUserBar = ->
    chartC.selectAll(".userbar").transition().duration(0)
        .attr("x", (d) -> d.x)
        .attr("y", (d) -> d.y)
        .attr("width", (d) -> d.width)
        .attr("height", (d) -> d.height)

resizeChart = (chart, idStr, state, spacing=1) ->
    dmin = state.earliestDate
    dmax = state.latestDate
    elementCount = state.daysInRange()
    console.log elementCount
    h = $(idStr).height() - globalChartCOffset.top
    tw = $(idStr).width()
    w = tw/(elementCount+spacing/2)
    if w < 5
        w = 5
    chart.selectAll(".bar").transition().duration(0)
    .attr("height",
            (d, i) ->
                return (position(d.end) - position(d.start)) * h)
    .attr("width",
            (d, i) ->
                return w)
    .attr("x",
        (d, i) ->
            xPosition(d.start, 0, $(idStr).width(), state.earliestDate, state.latestDate))
    .attr("y",
        (d, i) ->
            return position(d.start) * h + globalChartCOffset.top)

xPosition = (d, pmin, pmax, dmin, dmax) ->
  # convert d variables into a number representing
  # a number of days
  d = d.valueOf() / (1000 * 60 * 60 * 24)
  dmin = dmin.valueOf() / (1000 * 60 * 60 * 24)
  dmax = dmax.valueOf() / (1000 * 60 * 60 * 24)
  #console.log(d - dmin) / (dmax - dmin)
  Math.floor(d - dmin) / (dmax - dmin) * pmax



resizeLines = ->
  h = $('#current-chart').height() - globalChartCOffset.top 
  tw = $('#current-chart').width()
  chartC.selectAll("line").transition(0).duration(0)
    .attr("y1", (d) -> position(d) * h + globalChartCOffset.top)
    .attr("y2", (d) -> position(d) * h + globalChartCOffset.top)
    .attr("x1", 0)
    .attr("x2", tw)

  chartC.selectAll(".rule").transition(0).duration(0)
    .attr("y", (d) -> position(d) * h + globalChartCOffset.top)
    .attr("x", 0)
    .attr("dx", 35)

# maps a time (from a date object) to a ratio from 0 to 1
position = (d) ->
  ((d.getHours() + d.getMinutes() / 60 + d.getSeconds() / (60*60)) / 24 + 0.25) % 1

window.position = position


# you want n ticks on the graph: here're the dates you need
ticks = (n) ->
  ticks = []
  count = [0..n]
  for i in count
    tick = 1/n * i
    [hours, minutes, seconds] = timeFromY tick
    ticks.push(new Date(2012,1,1,hours, minutes, seconds))
  return ticks

# xTicks = (n) ->
#   ticks = []
#   count = [0..n]
#   for i in count
#     tick = 1/n * i
#     d = dateFromX


timeFromY = (y) ->
  y = (y - 0.25) % 1
  y += 1 if y < 0
  hours = y * 24
  minute_fraction = hours % 1
  minutes = minute_fraction * 60
  second_fraction = minute_fraction % 1
  seconds = second_fraction * 60

  return [hours, minutes, seconds]

dateFromX = (x, dmin, dmax, xmax) ->
  # convert dates to a number in the unit of days
  dmin = dmin.valueOf() / (1000 * 60 * 60 * 24)
  dmax = dmax.valueOf() / (1000 * 60 * 60 * 24)

  # function that creates a date based on the y position
  # note: doesn't create the correct time
  d = new Date(Math.floor(dmin + x * (dmax - dmin) / xmax ) * (1000 * 60 * 60 * 24))
  #console.log(d)
  return d

$('#current-chart').mousemove (e) ->
    h = $('#current-chart').height() - globalChartCOffset.top
    x = e.pageX - this.offsetLeft
    y = e.pageY - this.offsetTop - globalChartCOffset.top

    [hours, minutes, seconds] = timeFromY(y/h)
    d = new Date(2012,1,1,hours, minutes, seconds)

    console.log dateFromX(x, currentInteractionState.earliestDate, currentInteractionState.latestDate, $('#current-chart').width())
    # console.log formatTime(d)
    #console.log dateFromPosFrac(x,y/h)
    
    if currentInteractionState.dragState == 1
        x = e.pageX - this.offsetLeft
        y = e.pageY - this.offsetTop
        currentInteractionState.currentBar[0].width = x - currentInteractionState.currentBar[0].x
        currentInteractionState.currentBar[0].height = y - currentInteractionState.currentBar[0].y
        refreshUserBar()

$('#current-chart').mousedown (e) ->
    if currentInteractionState.dragState == 0
        x = e.pageX - this.offsetLeft
        y = e.pageY - this.offsetTop
        temp = new TempBar($('#current-chart'), x, y, 0, 0)
        #currentInteractionState.currentBar.push(temp)
        currentInteractionState.currentBar = [temp]
        createUserBar()
    currentInteractionState.dragState = 1

$('#current-chart').mouseup (e) ->
   currentInteractionState.dragState = 0 

window.morpheus.getDataForUser(
    ((response) ->
        for s in response
            newSleep = new Sleep s.start, s.end
            mainUser.sleeps.push(newSleep)
        #console.log mainUser.sleeps[-1..][0]
        console.log "earliest " + mainUser.sleeps[-8..][0].start
        console.log "latest " + mainUser.sleeps[-1..][0].end
        overviewState.setRange(mainUser.sleeps[0].start, mainUser.sleeps[-1..][0].end)
        currentInteractionState.setRange(mainUser.sleeps[-8..][0].start, mainUser.sleeps[-1..][0].end)
        updateOverview()
        updateCurrent()
        resizeLines()),
    'Gomez')

$(window).resize ->
    resizeChart(chartO, '#overview-chart', overviewState)
    resizeChart(chartC, '#current-chart', currentInteractionState, 10)
    resizeLines()


# using jQuery
getCookie = (name) ->
    cookieValue = null
    if (document.cookie && document.cookie != '')
        cookies = document.cookie.split(';')
        for cookie in cookies 
            cookie = jQuery.trim(cookie)
            # Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) == (name + '=')) 
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1))
                break
    return cookieValue

csrfSafeMethod = (method) ->
    # these HTTP methods do not require CSRF protection
    return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method))

$.ajaxSetup(
    crossDomain: false # obviates need for sameOrigin test
    beforeSend: (xhr, settings) ->
      if (!csrfSafeMethod(settings.type)) 
          xhr.setRequestHeader("X-CSRFToken", getCookie('csrftoken'))
)

# $('#current-chart').mousedown (e) ->
#     $('#current-chart').mousemove (e) ->

#     $('#current-chart').mouseup (e) ->
      

#     x = e.pageX - this.offsetLeft
#     y = e.pageY - this.offsetTop
#     h = $("#current-chart").height()
#     w = $("#current-chart").width()

#     [hours, minutes, seconds] = dateFromPosFrac(1, y / h)

#     start = new Date(2012,9,16,hours, minutes, seconds).valueOf()
#     end = new Date().valueOf()
#     data = 
#       "username": '{{ user.username }}'
#       "start": start
#       "end": end
#     $.post("/postdata/", data)
#     return false

