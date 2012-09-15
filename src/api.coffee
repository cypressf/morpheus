
window.morpheus =
    getDataForUser : (username, earliestDate=null, latestDate=null, callback) ->
        if startTime? and endTime?
            $.getJSON '/data/?username='+username+'&'+'earliestdate='+earliestDate+'&'+'latestdate='+latestDate, callback
        else
            $.getJSON '/data/?username='+username, callback

'''
putSleepForUser : (username, start, end, callback) ->
    $.post('/data/?')
    #Headers
    #Username
    #Start
    #End

    if startTime? and endTime?
        $.getJSON '/data/?username='+username
            +'&'+'earliestdate='+earliestDate
            +'&'+'latestdate='+latestDate, callback
    else
        $.getJSON '/data/?username='+username, callback
'''
