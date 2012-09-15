
randint = (a, b) ->
    Math.floor(Math.random()*(b-1)+a)

class Sleep
    constructor: (@user, @start, @end) ->

class User
    constructor: (@name) ->
        @sleeps = []

mainUser = new User 'Test'
for i in [1..20]
    sTime = randint 0, 5
    eTime = sTime + randint 3, 9
    s = new Sleep mainUser, sTime, eTime
    mainUser.sleeps.push s


chart = d3.select("body").append("svg")
    .attr("class", "chart")
    .attr("height", 500)
    .attr("width", 20 * mainUser.sleeps.length)

x = d3.scale.linear()
    .domain([0, d3.max(mainUser.sleeps)])
    .range([0, 500])

console.log d3.max(mainUser.sleeps)

chart.selectAll("rect")
    .data(mainUser.sleeps)
    .enter().append("rect")
    .attr("x",
        (d, i) ->
            return i * 20)
    .attr("y",
        (d, i) ->
            return d.start*20)
    .attr("height",
            (d, i) ->
                return (d.end - d.start) * 20)
    .attr("width", 20)
