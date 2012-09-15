# We only have the duration in the csv file, but maybe we can just add a
# random offset to simulate the importance of the data?

import csv
import datetime
import random
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
            d = float(self.duration)
            # Note: Hour is int in range 0-24
            randomHourOffset = 0 #random.randint(0,24) # TODO: Choose a good range for this random number generator
            # Duration will still be accurate, but start and end time will exist and be fake
            shour = datetime.timedelta(hours=randomHourOffset)
            ehour = datetime.timedelta(hours=randomHourOffset+int(d), minutes=int((d-int(d))*60.0))

            sdate = datetime.datetime(year, month, day) + shour
            edate = datetime.datetime(year, month, day) + ehour
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


