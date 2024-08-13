from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.hashers import make_password
from django.contrib.auth import get_user_model
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import User
from .serializers import UserSerializer
from django.shortcuts import redirect

# User CRUD Views
class UserListCreateView(generics.ListCreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = []  # Adjust as needed for your use case

    def get(self, request, *args, **kwargs):
        users = self.get_queryset()
        serializer = self.get_serializer(users, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

class UserDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = []  # Adjust as needed for your use case

    def get(self, request, *args, **kwargs):
        user = self.get_object()
        serializer = self.get_serializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request, *args, **kwargs):
        user = self.get_object()
        serializer = self.get_serializer(user, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def delete(self, request, *args, **kwargs):
        user = self.get_object()
        self.perform_destroy(user)
        return Response(status=status.HTTP_204_NO_CONTENT)

# User Authentication Views
class RegisterView(APIView):
    def get(self, request, *args, **kwargs):
        return Response({"detail": "Please provide username, password, email, and phone_number to register."}, status=status.HTTP_200_OK)

    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')
        email = request.data.get('email')
        phone_number = request.data.get('phone_number')

        User = get_user_model()
        if User.objects.filter(username=username).exists():
            return Response({"detail": "Username already exists."}, status=status.HTTP_400_BAD_REQUEST)

        user = User(
            username=username,
            email=email,
            phone_number=phone_number,
            password=make_password(password),  # Hash the password
            is_approved=False  # Set is_approved to False by default
        )
        user.save()
        return Response({"detail": "User created successfully. Please wait for admin approval."}, status=status.HTTP_201_CREATED)

    def put(self, request, *args, **kwargs):
        username = request.data.get('username')
        email = request.data.get('email')
        phone_number = request.data.get('phone_number')
        password = request.data.get('password')

        User = get_user_model()
        try:
            user = User.objects.get(username=username)
        except User.DoesNotExist:
            return Response({"detail": "User not found."}, status=status.HTTP_404_NOT_FOUND)

        if email:
            user.email = email
        if phone_number:
            user.phone_number = phone_number
        if password:
            user.password = make_password(password)  # Hash the new password

        user.save()
        return Response({"detail": "User updated successfully."}, status=status.HTTP_200_OK)

    def delete(self, request, *args, **kwargs):
        username = request.data.get('username')
        User = get_user_model()
        try:
            user = User.objects.get(username=username)
            user.delete()
            return Response({"detail": "User deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except User.DoesNotExist:
            return Response({"detail": "User not found."}, status=status.HTTP_404_NOT_FOUND)

class PendingView(APIView):
    def get(self, request, *args, **kwargs):
        return Response({"detail": "Please wait for admin approval."}, status=status.HTTP_200_OK)

class ApproveView(APIView):
    def get(self, request, *args, **kwargs):
        """
        Retrieve the approval status of a user.
        """
        username = request.query_params.get('username')
        if not username:
            return Response({"detail": "Username parameter is required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(username=username)
            return Response({
                "username": user.username,
                "is_approved": user.is_approved
            }, status=status.HTTP_200_OK)
        except User.DoesNotExist:
            return Response({"detail": "User not found."}, status=status.HTTP_404_NOT_FOUND)

    def post(self, request, *args, **kwargs):
        """
        Approve a user by setting their is_approved field to True.
        """
        username = request.data.get('username')
        if not username:
            return Response({"detail": "Username is required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(username=username)
            user.is_approved = True
            user.save()
            return Response({"detail": "User approved successfully."}, status=status.HTTP_200_OK)
        except User.DoesNotExist:
            return Response({"detail": "User not found."}, status=status.HTTP_404_NOT_FOUND)
User = get_user_model()

class LoginView(APIView):
    def get(self, request, *args, **kwargs):
        return Response({"detail": "Please provide username and password to log in."}, status=status.HTTP_200_OK)

    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')

        # Use authenticate to check the credentials
        user = User.objects.get(username=username, password=password)
        if user is None:
            return Response({"detail": "Invalid credentials."}, status=status.HTTP_400_BAD_REQUEST)

        # Check if the user is approved
        if not user.is_approved:
            return Response({"detail": "Your account is pending approval. Please wait for admin approval."}, status=status.HTTP_400_BAD_REQUEST)

        # Log the user in
        login(request, user)
        return Response({"detail": "Login successful.",
                         "username": user.username}, status=status.HTTP_200_OK)

    def delete(self, request, *args, **kwargs):
        logout(request)
        return Response({"detail": "Logged out successfully."}, status=status.HTTP_200_OK)