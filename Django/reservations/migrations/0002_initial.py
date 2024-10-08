# Generated by Django 5.1 on 2024-08-17 06:53

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('reservations', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name='car',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='reservation',
            name='car',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='reservations.car'),
        ),
        migrations.AddField(
            model_name='adminapproval',
            name='reservation',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='reservations.reservation'),
        ),
        migrations.AddField(
            model_name='userprofile',
            name='user',
            field=models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
    ]
