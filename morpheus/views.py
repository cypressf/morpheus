from django.http import HttpResponseRedirect
from django.contrib.auth import logout as auth_logout
from django.contrib.auth.decorators import login_required
from django.template import RequestContext
from django.shortcuts import render_to_response, redirect
from django.contrib.messages.api import get_messages

from social_auth.signals import pre_update
#from social_auth.backends.contrib
from social_auth import __version__ as version
from social_auth.utils import setting

def home(request):
    """Home view, displays login mechanism"""
    return render_to_response('home.html', RequestContext(request))
