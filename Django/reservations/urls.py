from django.urls import path
from .views import (
    UserProfileListCreateView, UserProfileDetailView,
    CarListCreateView, CarDetailView,
    ReservationListCreateView, ReservationDetailView,
    AdminApprovalListCreateView, AdminApprovalDetailView
)

urlpatterns = [
    # UserProfile URLs
    path('userprofiles/', UserProfileListCreateView.as_view(), name='userprofile-list-create'),
    path('userprofiles/<int:pk>/', UserProfileDetailView.as_view(), name='userprofile-detail'),

    # Car URLs
    path('cars/', CarListCreateView.as_view(), name='car-list-create'),
    path('cars/<int:pk>/', CarDetailView.as_view(), name='car-detail'),

    # Reservation URLs
    path('reservations/', ReservationListCreateView.as_view(), name='reservation-list-create'),
    path('reservations/<int:pk>/', ReservationDetailView.as_view(), name='reservation-detail'),

    # AdminApproval URLs
    path('adminapprovals/', AdminApprovalListCreateView.as_view(), name='adminapproval-list-create'),
    path('adminapprovals/<int:pk>/', AdminApprovalDetailView.as_view(), name='adminapproval-detail'),
]
