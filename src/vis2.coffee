
randint = (a, b) ->
    Math.floor(Math.random()*(b-1)+a)

class Sleep
    constructor: (@user, @start, @end) ->

class User
    constructor: (@name) ->
        @sleeps = []


mainUser = new User 'Test'
for i in [1..200]
    sTime = randint 0, 5
    eTime = sTime + randint 3, 9
    s = new Sleep mainUser, sTime, eTime
    mainUser.sleeps.push s

chart = d3.select("#overview-chart")

chart.selectAll("rect")
    .data(mainUser.sleeps)
    .enter().append("rect")
    .attr("x",
        (d, i) ->
            return i * 20)
    .attr("y",
        (d, i) ->
            return d.start*10)
    .attr("height",
            (d, i) ->
                return (d.end - d.start) * 10)
    .attr("width", 20)
