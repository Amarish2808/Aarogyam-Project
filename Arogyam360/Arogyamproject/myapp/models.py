from django.db import models
from django.contrib.auth.models import User
# Create your models here.



class Userprofile(models.Model):
    USER = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    email = models.CharField(max_length=200)
    phone = models.CharField(max_length=200)
    gender = models.CharField(max_length=200)
    age= models.CharField(max_length=200)
    address = models.CharField(max_length=200)
    place = models.CharField(max_length=200)

class Gymowner(models.Model):
    USER = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    email = models.CharField(max_length=200)
    phone = models.CharField(max_length=200)
    place = models.CharField(max_length=200, null=True, blank=True)
    address = models.CharField(max_length=200)
    idproof = models.FileField(upload_to='uploads')
    image = models.ImageField(upload_to='gymowners/', null=True, blank=True)
    fees = models.DecimalField(max_digits=8, decimal_places=2, null=True, blank=True)
    status  = models.CharField(max_length=200,default="pending")
    description = models.TextField(null=True, blank=True)


class Trainer(models.Model):
    GYM_OWNER = models.ForeignKey(Gymowner, on_delete=models.CASCADE)
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    image = models.ImageField(upload_to='gymowners/', null=True, blank=True)
    email = models.CharField(max_length=200)
    phone = models.CharField(max_length=200)
    qualification = models.CharField(max_length=200)
    experience = models.CharField(max_length=200)


class Workoutlevel(models.Model):
    GYM_OWNER = models.ForeignKey(Gymowner, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()

class Workoutroutine(models.Model):
    TRAINER = models.ForeignKey(Trainer, on_delete=models.CASCADE)
    WORKOUTLEVEL= models.ForeignKey(Workoutlevel, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    date = models.CharField(max_length=200,null=True,blank=True)
    description = models.TextField()

class Dailyexerciseplan(models.Model):
    TRAINER = models.ForeignKey(Trainer, on_delete=models.CASCADE)
    WORKOUTLEVEL = models.ForeignKey(Workoutlevel, on_delete=models.CASCADE)
    plantext = models.TextField()
    date = models.CharField(max_length=200)



class Medicalreport(models.Model):
    USERPROFILE = models.ForeignKey(Userprofile, on_delete=models.CASCADE)
    reporttitle = models.CharField(max_length=200)
    reportfile = models.FileField(upload_to='uploads')
    description = models.CharField(max_length=200)
    date = models.CharField(max_length=200)

class Aisummary(models.Model):
    MEDICALREPORT = models.ForeignKey(Medicalreport, on_delete=models.CASCADE)
    USERPROFILE = models.ForeignKey(Userprofile, on_delete=models.CASCADE)
    summary = models.TextField()
    date = models.CharField(max_length=200)



class Dietplans(models.Model):
    MEDICALREPORT = models.ForeignKey(Medicalreport, on_delete=models.CASCADE)
    USERPROFILE = models.ForeignKey(Userprofile, on_delete=models.CASCADE)
    dietplan = models.TextField()
    date = models.CharField(max_length=200)


class Request(models.Model):
    GYM_OWNER = models.ForeignKey(Gymowner, on_delete=models.CASCADE)
    USERPROFILE = models.ForeignKey(Userprofile, on_delete=models.CASCADE)
    description = models.CharField(max_length=200)
    date = models.CharField(max_length=200)
    status = models.CharField(max_length=20, default="pending")


class Payment(models.Model):
    USERPROFILE = models.ForeignKey(Userprofile, on_delete=models.CASCADE)
    GYM_OWNER = models.ForeignKey(Gymowner, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=8, decimal_places=2)
    payment_date = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, default="Paid")



class Category(models.Model):
    categoryname = models.CharField(max_length=200)

class Products(models.Model):
    CATEGORY = models.ForeignKey(Category, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()
    image = models.FileField(upload_to='uploads')
    url = models.TextField()



class Complaints(models.Model):
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    complaint = models.CharField(max_length=200)
    reply = models.CharField(max_length=200)
    date = models.CharField(max_length=200)


class Feedback(models.Model):
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    TRAINER = models.ForeignKey(Trainer, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    feedback = models.CharField(max_length=200)
    date = models.CharField(max_length=200)





class Notification(models.Model):
    GYM_OWNER = models.ForeignKey(Gymowner, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    message = models.TextField()
    target = models.CharField(max_length=20)   # trainers / users / all
    date = models.DateTimeField(auto_now_add=True)



class AdminMaintenance(models.Model):
    PAYMENT = models.ForeignKey(Payment, on_delete=models.CASCADE)
    USERPROFILE = models.ForeignKey(Userprofile, on_delete=models.CASCADE)
    GYM_OWNER = models.ForeignKey(Gymowner, on_delete=models.CASCADE)

    total_amount = models.DecimalField(max_digits=8, decimal_places=2)
    admin_share = models.DecimalField(max_digits=8, decimal_places=2)
    gym_share = models.DecimalField(max_digits=8, decimal_places=2)

    date = models.DateTimeField(auto_now_add=True)