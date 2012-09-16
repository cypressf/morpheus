
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
  
updateCurrent = ->
    tick_count = 10
    the_ticks = ticks(tick_count)
    h = $('#current-chart').height()  
    tw = $('#current-chart').width()
    chartC.selectAll("rect")
        .data(mainUser.sleeps[-7..])
        .enter().append("rect")
        .attr("y",
            (d, i) ->
                return position(d.start) * h)
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
      .attr("dx", 8)
      .attr("text-anchor", "middle")
      .text((d) -> d.getHours())
    

resizeChart = (chart, idStr, elementCount, spacing=1) ->
    h = $(idStr).height()
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
            return position(d.start) * h)

resizeLines = ->
  h = $('#current-chart').height()  
  tw = $('#current-chart').width()
  chartC.selectAll("line").transition(0).duration(0)
    .attr("y1", (d) -> position(d) * h)
    .attr("y2", (d) -> position(d) * h)
    .attr("x1", 0)
    .attr("x2", tw)

# maps a time (from a date object) to a ratio from 0 to 1
position = (d) ->
  ((d.getHours() + d.getMinutes() / 60 + d.getSeconds() / (60*60)) / 24 + 0.25) % 1

# you want n ticks on the graph: here're the dates you need
ticks = (n) ->
  ticks = []
  for tick in [0..1] by 1 / n
    [hours, minutes, seconds] = gettime tick
    ticks.push(new Date(2012,1,1,hours, minutes, seconds))
  console.log(ticks)
  return ticks

gettime = (n) ->
  n = (n - 0.25) % 1
  n += 1 if n < 0
  hours = n * 24
  minute_fraction = hours % 1
  minutes = minute_fraction * 60
  second_fraction = minute_fraction % 1
  seconds = second_fraction * 60
  return [hours, minutes, seconds]

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

csrfSafeMethod(method) ->
    # these HTTP methods do not require CSRF protection
    return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method))

$.ajaxSetup(
    crossDomain: false # obviates need for sameOrigin test
    beforeSend: (xhr, settings) ->
      if (!csrfSafeMethod(settings.type)) 
          xhr.setRequestHeader("X-CSRFToken", getCookie('csrftoken'))
)

$('#current-chart').mousedown (e) ->
    $('#current-chart').mousemove (e) ->

    $('#current-chart').mouseup (e) ->
      

    x = e.pageX - this.offsetLeft
    y = e.pageY - this.offsetTop
    h = $("#current-chart").height()
    w = $("#current-chart").width()

    [hours, minutes, seconds] = gettime(y / h)

    start = new Date(2012,9,16,hours, minutes, seconds).valueOf()
    end = new Date().valueOf()
    data = 
      "username": '{{ user.username }}'
      "start": start
      "end": end
    $.post("/postdata/", data)
    return false

