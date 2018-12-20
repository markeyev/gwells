# Generated by Django 2.1.4 on 2018-12-06 01:22

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('wells', '0039_auto_20181206_0017'),
    ]

    operations = [
        migrations.AddField(
            model_name='activitysubmission',
            name='well_status',
            field=models.ForeignKey(blank=True, db_column='well_status_code', null=True, on_delete=django.db.models.deletion.CASCADE, to='wells.WellStatusCode', verbose_name='Well Status'),
        ),
    ]
