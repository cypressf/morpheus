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
import json

def home(request):
    """Home view, displays login mechanism"""
    if request.user.is_authenticated():
        return HttpResponseRedirect('done')
    else:
        return render_to_response('home.html', {'version': version},
                                  RequestContext(request))

@login_required
def done(request):
    """Login complete view, displays user data"""
    ctx = {
        'version': version,
        'last_login': request.session.get('social_auth_last_login_backend')
    }
    return render_to_response('done.html', ctx, RequestContext(request))

def logout(request):
    """Logs out user"""
    auth_logout(request)
    return HttpResponseRedirect('/')

def data(request):
    if 'earliestdate' in request.GET:
        earliestdate = request.GET['earliestdate']
    if 'earliestdate' in request.GET:
        latestdate = request.GET['latestdate']
    if 'username' in request.GET:
        username = request.GET['username']
    sleeps_json = json.dumps([])
    if username:
        u = User.objects.filter(username__exact=username)
        if u:
            sleeps = u[0].sleep_set.all()
            sleeps_dict = [{"start": s.start.isoformat(), "end": s.end.isoformat()} for s in sleeps]
            sleeps_json = json.dumps(sleeps_dict)

    return HttpResponse(sleeps_json, mimetype="application/json")