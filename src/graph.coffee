
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
              return d.start.getHours()*10)
      .attr("height",
              (d, i) ->
                  return (d.end.getHours() - d.start.getHours()) * h/25.0)
      .attr("width", 5)
  
updateCurrent = ->
    h = $('#current-chart').height()                     
    chartC.selectAll("rect")
        .data(mainUser.sleeps[-7..])
        .enter().append("rect")
        .attr("y",
            (d, i) ->
                return d.start.getHours())
        .attr("height",
                (d, i) ->
                    return (d.end.getHours() - d.start.getHours()) * h/25.0)
        .attr("width",
                (d, i) ->
                    return 60)
        .attr("x",
            (d, i) ->
                return i*62)
    

resizeChart = (chart, idStr, elementCount, spacing=1) ->
    h = $(idStr).height()  
    tw = $(idStr).width()
    w = tw/(elementCount+spacing/2)
    if w < 5
        w = 5
    chart.selectAll("rect").transition().duration(0)
    .attr("height",
            (d, i) ->
                return (d.end.getHours() - d.start.getHours()) * h/25.0)
    .attr("width",
            (d, i) ->
                return w)
    .attr("x",
        (d, i) ->
            return (i * (w+spacing)) + (tw-(w+spacing)*(elementCount+1)))


window.morpheus.getDataForUser(
    ((response) ->
        for s in response
            newSleep = new Sleep s.start, s.end
            mainUser.sleeps.push(newSleep)
        updateOverview()
        updateCurrent()
        resizeChart(chartO, '#overview-chart', mainUser.sleeps.length)
        resizeChart(chartC, '#current-chart', 7, 10)),
    'Gomez')

$(window).resize ->
    resizeChart(chartO, '#overview-chart', mainUser.sleeps.length)
    resizeChart(chartC, '#current-chart', 7, 10)

