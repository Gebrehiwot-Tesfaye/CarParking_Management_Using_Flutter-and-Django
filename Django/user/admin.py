from django.contrib import admin
from django.contrib.admin.models import LogEntry
from django.utils.translation import gettext_lazy as _

from .models import User

admin.site.site_header = "Welcome to Ashewa Car Slot Reservation"
admin.site.site_title = "Ashewa Car Slot Reservation Admin"
admin.site.index_title = "Ashewa Car Slot Reservation Administration"

class UserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'first_name', 'last_name','phone_number','is_approved')
    search_fields = ('username', 'email', 'first_name', 'last_name')

admin.site.register(User, UserAdmin)