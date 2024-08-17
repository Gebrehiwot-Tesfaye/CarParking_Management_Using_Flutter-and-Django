from django.db import models
from django.conf import settings

class UserProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    profile_image = models.ImageField(upload_to='profile_images', blank=True, null=True)

    def __str__(self):
        return self.user.get_full_name() or self.user.username

    def username(self):
        return self.user.username

    def first_name(self):
        return self.user.first_name

    def last_name(self):
        return self.user.last_name

    def email(self):
        return self.user.email    
    def phone_number(self):
        return self.user.phone_number

class Car(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    model = models.CharField(max_length=100)
    vin = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return f'{self.model} ({self.vin}) - Owned by {self.user.username}'
class Reservation(models.Model):
    car = models.ForeignKey(Car, on_delete=models.CASCADE)
    car_slot = models.CharField(max_length=100,unique=True)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    is_approved = models.BooleanField(default=False)  # Added field

    def __str__(self):
        return f'Reservation for {self.car.model} in slot {self.car_slot} from {self.start_time} to {self.end_time}'

class AdminApproval(models.Model):
    reservation = models.ForeignKey(Reservation, on_delete=models.CASCADE)
    approved = models.BooleanField(default=False)
    feedback = models.TextField(blank=True, null=True)

    def __str__(self):
        approval_status = 'Approved' if self.approved else 'Not Approved'
        return f'{approval_status} - Reservation: {self.reservation}'
