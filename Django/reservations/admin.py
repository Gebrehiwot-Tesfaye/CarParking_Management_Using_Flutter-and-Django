from django.contrib import admin
from django.utils.translation import gettext_lazy as _

from .models import UserProfile, Car, Reservation, AdminApproval

class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'profile_image', 'first_name', 'last_name', 'email', 'phone_number')
    search_fields = ('user__username', 'user__first_name', 'user__last_name', 'user__email', 'user__phone_number')

class CarAdmin(admin.ModelAdmin):
    list_display = ('model', 'vin', 'user')
    search_fields = ('model', 'vin', 'user__username')

class ReservationAdmin(admin.ModelAdmin):
    list_display = ('car', 'start_time', 'end_time')
    search_fields = ('car__model', 'car__vin', 'start_time', 'end_time')

class AdminApprovalAdmin(admin.ModelAdmin):
    list_display = ('reservation', 'approved', 'feedback')
    search_fields = ('reservation__car__model', 'reservation__car__vin', 'approved', 'feedback')

admin.site.register(UserProfile, UserProfileAdmin)
admin.site.register(Car, CarAdmin)
admin.site.register(Reservation, ReservationAdmin)
admin.site.register(AdminApproval, AdminApprovalAdmin)