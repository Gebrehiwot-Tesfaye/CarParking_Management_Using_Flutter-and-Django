from django.urls import path
from .views import UserListCreateView, UserDetailView, RegisterView, LoginView, PendingView, ApproveView

urlpatterns = [
    path('user-register/', UserListCreateView.as_view(), name='user-list-create'),
    path('users/<int:pk>/', UserDetailView.as_view(), name='user-detail'),
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('pending/', PendingView.as_view(), name='pending'),
    path('approve/', ApproveView.as_view(), name='approve'),
]