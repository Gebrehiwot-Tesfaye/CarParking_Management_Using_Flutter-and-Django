from django.urls import path
from .views import (
    UserProfileListCreateView, UserProfileDetailView,
    CarListCreateView, CarDetailView,
    ReservationListCreateView, ReservationDetailView,
    AdminApprovalListCreateView, AdminApprovalDetailView
)

urlpatterns = [
    path('user-profiles/', UserProfileListCreateView.as_view(), name='userprofile-list-create'),
    path('user-profiles/<int:user_id>/', UserProfileDetailView.as_view(), name='userprofile-detail'),
    path('users/<int:user_id>/cars/', CarListCreateView.as_view(), name='user-cars'),

    # URL for retrieving, updating, or deleting a specific car
    path('cars/<int:pk>/', CarDetailView.as_view(), name='car-detail'),
    path('reservations/', ReservationListCreateView.as_view(), name='reservation-list-create'),
    path('reservations/<int:pk>/', ReservationDetailView.as_view(), name='reservation-detail'),
    path('admin-approvals/', AdminApprovalListCreateView.as_view(), name='adminapproval-list-create'),
    path('admin-approvals/<int:pk>/', AdminApprovalDetailView.as_view(), name='adminapproval-detail'),
]
