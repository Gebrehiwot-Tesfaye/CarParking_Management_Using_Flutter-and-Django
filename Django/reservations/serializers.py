from rest_framework import serializers
from .models import UserProfile, Car, Reservation, AdminApproval
from user.models import User

# User Serializer
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'phone_number', 'first_name', 'last_name', 'password')
        extra_kwargs = {
            'password': {'write_only': True}  # Ensure the password is write-only and not returned in the response
        }

    def create(self, validated_data):
        # Override the create method to hash the password
        password = validated_data.pop('password', None)
        user = self.Meta.model(**validated_data)
        if password is not None:
            user.set_password(password)  # Hash the password
        user.save()
        return user

# UserProfile Serializer
class UserProfileSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())

    class Meta:
        model = UserProfile
        fields = ['user', 'profile_image']

    def create(self, validated_data):
        user = validated_data.get('user')
        profile_image = validated_data.get('profile_image')

        # Check if UserProfile already exists for the given user
        user_profile, created = UserProfile.objects.update_or_create(
            user=user,
            defaults={'profile_image': profile_image}
        )
        return user_profile
# Car Serializer
class CarSerializer(serializers.ModelSerializer):
    user = UserProfileSerializer()  # Nested for GET requests

    class Meta:
        model = Car
        fields = ['user', 'model', 'vin']

class SimpleCarSerializer(serializers.ModelSerializer):
    user_profile_id = serializers.PrimaryKeyRelatedField(queryset=UserProfile.objects.all(), source='user')

    class Meta:
        model = Car
        fields = ['id', 'model', 'vin', 'user_profile_id']

    def create(self, validated_data):
        user_profile = validated_data.pop('user')
        car = Car.objects.create(user=user_profile, **validated_data)
        return car

    def update(self, instance, validated_data):
        user_profile = validated_data.pop('user', None)
        if user_profile is not None:
            instance.user = user_profile
        instance.model = validated_data.get('model', instance.model)
        instance.vin = validated_data.get('vin', instance.vin)
        instance.save()
        return instance

# Reservation Serializer
class ReservationSerializer(serializers.ModelSerializer):
    car = CarSerializer()  # Nested for GET requests

    class Meta:
        model = Reservation
        fields = ['car', 'start_time', 'end_time']

class SimpleReservationSerializer(serializers.ModelSerializer):
    car_id = serializers.PrimaryKeyRelatedField(queryset=Car.objects.all(), source='car')

    class Meta:
        model = Reservation
        fields = ['start_time', 'end_time', 'car_id']

    def create(self, validated_data):
        car = validated_data.pop('car')
        reservation = Reservation.objects.create(car=car, **validated_data)
        return reservation

    def update(self, instance, validated_data):
        car = validated_data.pop('car', None)
        if car is not None:
            instance.car = car
        instance.start_time = validated_data.get('start_time', instance.start_time)
        instance.end_time = validated_data.get('end_time', instance.end_time)
        instance.save()
        return instance

# AdminApproval Serializer
class AdminApprovalSerializer(serializers.ModelSerializer):
    reservation = ReservationSerializer()  # Nested for GET requests

    class Meta:
        model = AdminApproval
        fields = ['reservation', 'approved', 'feedback']

class SimpleAdminApprovalSerializer(serializers.ModelSerializer):
    reservation_id = serializers.PrimaryKeyRelatedField(queryset=Reservation.objects.all(), source='reservation')

    class Meta:
        model = AdminApproval
        fields = ['approved', 'feedback', 'reservation_id']

    def create(self, validated_data):
        reservation = validated_data.pop('reservation')
        admin_approval = AdminApproval.objects.create(reservation=reservation, **validated_data)
        return admin_approval

    def update(self, instance, validated_data):
        reservation = validated_data.pop('reservation', None)
        if reservation is not None:
            instance.reservation = reservation
        instance.approved = validated_data.get('approved', instance.approved)
        instance.feedback = validated_data.get('feedback', instance.feedback)
        instance.save()
        return instance
