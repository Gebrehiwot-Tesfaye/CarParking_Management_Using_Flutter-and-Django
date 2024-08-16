from rest_framework import generics
from rest_framework.exceptions import NotFound
from .models import UserProfile, Car, Reservation, AdminApproval
from .serializers import (
    UserProfileSerializer, CarSerializer, ReservationSerializer, AdminApprovalSerializer,
    SimpleCarSerializer, SimpleReservationSerializer, SimpleAdminApprovalSerializer
)

# UserProfile ListCreateView for POST and GET
class UserProfileListCreateView(generics.ListCreateAPIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer

    def perform_create(self, serializer):
        # Ensure create or update logic is used as in the serializer
        serializer.save()

# UserProfile RetrieveUpdateDestroyView for GET, PUT, PATCH, DELETE
class UserProfileDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = UserProfileSerializer

    def get_object(self):
        user_id = self.kwargs.get('user_id')
        try:
            return UserProfile.objects.get(user__id=user_id)
        except UserProfile.DoesNotExist:
            raise NotFound("UserProfile not found")

# Car ListCreateView for POST and GET
class CarListCreateView(generics.ListCreateAPIView):
    serializer_class = CarSerializer

    def get_queryset(self):
        user_id = self.kwargs.get('user_id')
        return Car.objects.filter(user__id=user_id)

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return CarSerializer
        return SimpleCarSerializer

# Car RetrieveUpdateDestroyView for GET, PUT, PATCH, DELETE
class CarDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Car.objects.all()

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return CarSerializer
        return SimpleCarSerializer
# Reservation ListCreateView for POST and GET
class ReservationListCreateView(generics.ListCreateAPIView):
    queryset = Reservation.objects.all()

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return ReservationSerializer
        return SimpleReservationSerializer

# Reservation RetrieveUpdateDestroyView for GET, PUT, PATCH, DELETE
class ReservationDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Reservation.objects.all()

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return ReservationSerializer
        return SimpleReservationSerializer

# AdminApproval ListCreateView for POST and GET
class AdminApprovalListCreateView(generics.ListCreateAPIView):
    queryset = AdminApproval.objects.all()

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return AdminApprovalSerializer
        return SimpleAdminApprovalSerializer

# AdminApproval RetrieveUpdateDestroyView for GET, PUT, PATCH, DELETE
class AdminApprovalDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = AdminApproval.objects.all()

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return AdminApprovalSerializer
        return SimpleAdminApprovalSerializer
