from django.http import HttpResponseRedirect
from django.http import HttpResponse

from django.contrib.auth import logout as auth_logout
from django.contrib.auth.decorators import login_required
from django.template import RequestContext
from django.shortcuts import render_to_response, redirect
from django.contrib.messages.api import get_messages

from social_auth.signals import pre_update
#from social_auth.backends.contrib
from social_auth import __version__ as version
from social_auth.utils import setting
from datetime import datetime
from django.contrib.auth.models import User
from morpheus.models import Sleep
import json

def home(request):
    """Home view, displays login mechanism"""
    if request.user.is_authenticated():
        return HttpResponseRedirect('user/'+request.user.username)
    else:
        return render_to_response('home.html', {'version': version},
                                  RequestContext(request))

@login_required
def graph(request):
    """Login complete view, displays user data"""
    ctx = {
        'version': version,
        'last_login': request.session.get('social_auth_last_login_backend')
    }
    return render_to_response('graph.html', ctx, RequestContext(request))

def logout(request):
    """Logs out user"""
    auth_logout(request)
    return HttpResponseRedirect('/')

def data(request):
    """
    Given a GET request with "earliestdate", "latestdate", and "username",
    return a JSON string in the format
    [{"start": date1, "end": date2}, {"start": date3, "end": date4}]
    where the dates are iso format date strings, representing the start and end
    of a sleep session.
    """
    sleeps = []
    u = None
    if 'username' in request.GET:
        username = request.GET['username']
        u = User.objects.filter(username__exact = username)
        print u
    if u:
        sleeps = Sleep.objects.filter(user__username = username)
    if u and ('earliestdate' in request.GET):
        earliestdate = datetime.fromtimestamp(request.GET['earliestdate'] / 1000.0)
        sleeps = sleeps.filter(start__gte = earliestdate)
    if u and ('latestdate' in request.GET):
        latestdate = datetime.fromtimestamp(request.GET['latestdate'] / 1000.0)
        sleeps = sleeps.filter(end_lte = latestdate)

    sleeps_dict = [{"start": s.start.isoformat(), "end": s.end.isoformat()} for s in sleeps]
    sleeps_json = json.dumps(sleeps_dict)

    return HttpResponse(sleeps_json, mimetype="application/json")

def post_data(request):
    """
    Given a POST request, with the headers "username", "start", and "end", 
    put the data in the database and return a confirmation when complete.
    """
    pass


