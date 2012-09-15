# We only have the duration in the csv file, but maybe we can just add a
# random offset to simulate the importance of the data?

import csv
import datetime
# TODO: Import django stuff

sleepdata = dict()

class Sleep():
    # XXX: Actually get rid of this and import django version
    def __init__(self, start=None, end=None, user=None):
        pass

    def save(self):
        pass

def makeUserFromName(nameStr):
    # TODO: Implement using Django
    pass

def getUserByName(nameStr):
    # TODO: Implement using Django
    return None


class SleepDurObject():
    def __init__(self, person, day, duration):
        self.person = person
        self.day = day
        self.duration = duration

        self.savetodb()

    def savetodb(self):
        if self.day != '' and self.duration != '':
            try:
                month,day,year = self.day.split('/')
            except Exception as e:
                print e
                print self.day
            day = int(day)
            month = int(month)
            year = int(year)
            # Note: Hour is int in range 0-24
            offset = 0 #TODO: Randomize?
            shour = 0 + offset
            ehour = float(self.duration) + offset
            sdate = datetime.datetime(year, month, day, int(shour), int((shour-int(shour))*60.0))
            edate = datetime.datetime(year, month, day, int(ehour), int((shour-int(shour))*60.0))
            usr = getUserByName(self.person)
            slp = Sleep(start=sdate, end=edate, user=usr)
            slp.save()

    def __repr__(self):
        return '['+'person: '+self.person+' | day: '+self.day+' | duration: '+self.duration+']'

with open("Sleep Stalker Fall 2011 - Sheet1.csv") as rawdata:
    datareader = csv.reader(rawdata, delimiter=',')
    daterow = []
    for possibledaterow in datareader:
        if 'Date' in possibledaterow:
            daterow = possibledaterow
            break
    for personrow in datareader:
        name = personrow[0]
        if name == '':
            break
        makeUserFromName(name)
        for date, duration in zip(daterow[1:], personrow[1:]):
            if date == '':
                break
            temp = sleepdata.get(name, [])
            sleepdata[name] = temp
            sleepdata[name].append(SleepDurObject(name, date, duration))

print sleepdata


