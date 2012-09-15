
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
  chartO.selectAll("rect")
      .data(mainUser.sleeps)
      .enter().append("rect")
      .attr("x",
          (d, i) ->
              return i * 6)
      .attr("y",
          (d, i) ->
              return d.start.getHours()*10)
      .attr("height",
              (d, i) ->
                  return (d.end.getHours() - d.start.getHours()) * 10)
      .attr("width", 5)


window.morpheus.getDataForUser(
    ((response) ->
        for s in response
            newSleep = new Sleep s.start, s.end
            mainUser.sleeps.push(newSleep)
            updateOverview()
        console.log response),
    'Gomez')




'''
for i in [1..200]
    sTime = randint 0, 5
    eTime = sTime + randint 3, 9
    s = new Sleep mainUser, sTime, eTime
    mainUser.sleeps.push s
'''



'''
chartC.selectAll("rect")
    .data(mainUser.sleeps[-7..])
    .enter().append("rect")
    .attr("x",
        (d, i) ->
            return i * 20)
    .attr("y",
        (d, i) ->
            return d.start*10)
    .attr("height",
            (d, i) ->
                return (d.end.getHour() - d.start.getHour()) * 10)
    .attr("width", 20)
'''
