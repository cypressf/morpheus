from django.db import models
from datetime import datetime
from django.contrib.auth.models import User

# uncomment to create user profiles
# class UserProfile(models.Model):
#     # This field is required.
#     user = models.OneToOneField(User)

#     # Other fields here

class Sleep(models.Model):
    start = models.DateTimeField(unique=False)
    end = models.DateTimeField(unique=False)
    user = models.ForeignKey(User, unique=False)