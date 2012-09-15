from django.conf.urls import patterns, include, url
import social_auth

from django.contrib import admin
admin.autodiscover()


urlpatterns = patterns('morpheus.views',
    # Examples:
    # url(r'^$', 'thesite.views.home', name='home'),
    # url(r'^thesite/', include('thesite.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
    url(r'^$', 'home', name='home'),
    url(r'^done/$', 'done', name='done'),
    url(r'^logout/$', 'logout', name='logout'),
    url(r'', include('social_auth.urls')),
    url(r'^admin/', include(admin.site.urls)),
)
