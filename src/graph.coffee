
randint = (a, b) ->
    Math.floor(Math.random()*(b-1)+a)

class User
    constructor: (@name) ->
        @sleeps = []

class Sleep
    constructor: (@start, @end) ->
        @start = new Date(@start)
        @end = new Date(@end)
        
mainUser = new User 'Gomez'

chartO = d3.select("#overview-chart")
chartC = d3.select("#current-chart")
globalChartCOffset =
  top : 50

updateOverview = ->
  h = $('#overview-chart').height()
  chartO.selectAll("rect").data(mainUser.sleeps)
      .enter().append("rect")
      .attr("x",
          (d, i) ->
              return i * 6)
      .attr("y",
          (d, i) ->
              return position(d.start) * h)
      .attr("height",
          (d, i) ->
              return (position(d.end) - position(d.start)) * h)
      .attr("width", 5)

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

updateCurrent = ->
    tick_count = 8
    the_ticks = ticks(tick_count)
    h = $('#current-chart').height() - globalChartCOffset.top  
    tw = $('#current-chart').width()
    chartC.selectAll("rect")
        .data(mainUser.sleeps[-7..])
        .enter().append("rect")
        .attr("y",
            (d, i) ->
                return position(d.start) * h + globalChartCOffset.top)
        .attr("height",
            (d, i) ->
                return (position(d.end) - position(d.start)) * h)
        .attr("width",
            (d, i) ->
                return 60)
        .attr("x",
            (d, i) ->
                return i*62)
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

resizeChart = (chart, idStr, elementCount, spacing=1) ->
    h = $(idStr).height() - globalChartCOffset.top
    tw = $(idStr).width()
    w = tw/(elementCount+spacing/2)
    if w < 5
        w = 5
    chart.selectAll("rect").transition().duration(0)
    .attr("height",
            (d, i) ->
                return (position(d.end) - position(d.start)) * h)
    .attr("width",
            (d, i) ->
                return w)
    .attr("x",
        (d, i) ->
            return (i * (w+spacing)) + (tw-(w+spacing)*(elementCount+1)))
    .attr("y",
        (d, i) ->
            return position(d.start) * h + globalChartCOffset.top)

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

dateFromPosFrac = (x,y) ->
  vert = (y-0.25)%1
  vertScaled = vert * 24
  hours = vertScaled
  minutes = (hours%1)*60
  seconds = (minutes%1)*60*60
  d = new Date()
  d.setHours(hours)
  d.setMinutes(minutes)
  d.setSeconds(seconds)
  return d
  #return hours

# you want n ticks on the graph: here're the dates you need
ticks = (n) ->
  ticks = []
  for tick in [0..1] by 1 / n
    tick = (tick - 0.25) % 1
    tick += 1 if tick < 0
    hours = tick * 24
    minute_fraction = hours % 1
    minutes = minute_fraction * 60
    second_fraction = minute_fraction % 1
    seconds = second_fraction * 60
    ticks.push(new Date(2012,1,1,hours, minutes, seconds))
  return ticks

currentInteractionState = 
  isMakingBar : false

$('#current-chart').mousemove (e) ->
    h = $('#current-chart').height() - globalChartCOffset.top
    x = e.pageX - this.offsetLeft
    y = e.pageY - this.offsetTop + globalChartCOffset.top

    d = dateFromPosFrac(x,y/h)
    #console.log formatTime(d)
    #console.log dateFromPosFrac(x,y/h)


window.morpheus.getDataForUser(
    ((response) ->
        for s in response
            newSleep = new Sleep s.start, s.end
            mainUser.sleeps.push(newSleep)
        updateOverview()
        updateCurrent()
        resizeChart(chartO, '#overview-chart', mainUser.sleeps.length)
        resizeChart(chartC, '#current-chart', 7, 10)
        resizeLines()),
    'Gomez')

$(window).resize ->
    resizeChart(chartO, '#overview-chart', mainUser.sleeps.length)
    resizeChart(chartC, '#current-chart', 7, 10)
    resizeLines()

