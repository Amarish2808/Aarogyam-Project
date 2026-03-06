from django.contrib.auth import authenticate , login as auth_login,logout
from django.http import JsonResponse
from django.shortcuts import render,redirect
from django.views.decorators.cache import never_cache
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User, Group
from django.contrib import messages
from myapp.models import *
from django.contrib.auth.decorators import login_required

from django.shortcuts import render, redirect, get_object_or_404
from datetime import date

# Create your views here.



def home(request):
    return render(request,'public_home.html')


@csrf_exempt
@never_cache
def login(request):
    if request.method == "POST":
        username = request.POST['username']
        password = request.POST['password']
        a = User.objects.filter(username=username).first()
        if a:
            if username == a.username:

                user = authenticate(request, username=username, password=password)
                print("USER : ", user)

                if user is not None:
                    auth_login(request, user)
                    request.session['user_id'] = user.id

                    if user.groups.filter(name='admin').exists():
                        return redirect('adminindex')

                    elif user.groups.filter(name='gymowner').exists():

                        gymown = Gymowner.objects.get(USER=user)
                        if gymown.status.lower() == 'approved':
                            request.session['gymowner_id'] = gymown.id
                            return redirect('gymowner')
                        else:
                            messages.warning(
                                request,
                                "Your  profile is not approved yet. Current status: {testator.status}."
                            )
                            return redirect('login')

                    elif user.groups.filter(name='trainer').exists():

                        train = Trainer.objects.get(USER=user)
                        request.session['trainer_id'] = train.id
                        return redirect('trainer')



                    else:
                        messages.error(request, 'Invalid user')
                        return redirect('login')
                else:
                    messages.error(request, 'Username or password incorrect')
            else:
                messages.error(request, 'Invalid username')
                return redirect('login')

        else:
            messages.error(request, 'No such user exist in this platform')
            return redirect('login')
    return render(request, 'login.html')



@login_required(login_url='login')
@never_cache
def logout_view(request):
    logout(request)              # Django logout
    request.session.flush()      # Clear session
    messages.success(request, "Logged out successfully.")
    return redirect('login')     # Redirect to login page



@login_required(login_url='login')
@never_cache
def adminindex(request):
    return render(request,'adminindex.html')


@login_required(login_url='login')
@never_cache
def admin_verifygymowner(request):
    adgym=Gymowner.objects.all()
    return render(request,'admin_verifygymowner.html',{'gym':adgym})




import smtplib
from django.shortcuts import redirect
from .models import Gymowner

def admin_approvegymowner(request, id):

    idgym = Gymowner.objects.get(id=id)

    idgym.status = "Approved"
    idgym.save()

    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login("safedore3@gmail.com", "yqqlwlyqbfjtewam")

    to = idgym.email
    subject = "Gym Owner Request Approved"

    body = f"""
Hello {idgym.name},

Your gym owner registration request is approved.

Now you can login to the system.

Thank You.
"""

    msg = f"Subject: {subject}\n\n{body}"

    server.sendmail("safedore3@gmail.com", to, msg)

    server.quit()

    return redirect("admin_verifygymowner")




def admin_rejectgymowner(request,id):
    idgym=Gymowner.objects.get(id=id)
    idgym.status="Rejected"
    idgym.save()
    return redirect("admin_verifygymowner")



@login_required(login_url='login')
@never_cache
def admin_complaint(request):
    comp=Complaints.objects.all()
    return render(request,'admin_complaint.html',{'comp':comp})



@login_required(login_url='login')
@never_cache
def admin_complaintreply(request, id):
    complaint = get_object_or_404(Complaints,id=id)

    if request.method == "POST":
        reply = request.POST.get("reply")
        complaint.reply = reply
        complaint.save()
        return redirect('admin_complaint')

    return render(request, 'admin_complaintreply.html', {
        'complaint': complaint
    })




@login_required(login_url='login')
@never_cache
def admin_view_feedback(request):

    feedbacks = Feedback.objects.select_related(
        'USER',
        'TRAINER',
        'TRAINER__GYM_OWNER'
    ).order_by('-id')

    data = []

    for f in feedbacks:
        data.append({
            'user': f.USER.username,
            'trainer': f.TRAINER.name,
            'gym': f.TRAINER.GYM_OWNER.name,
            'title': f.title,
            'feedback': f.feedback,
            'date': f.date
        })

    return render(request, 'admin_feedback.html', {'feedbacks': data})



@login_required(login_url='login')
@never_cache
def admin_category(request):
    if request.method == "POST":
        action = request.POST.get('action')  # add, edit, delete
        category_id = request.POST.get('category_id')
        categoryname = request.POST.get('categoryname')

        # ADD category
        if action == "add":
            if categoryname:
                if Category.objects.filter(categoryname=categoryname).exists():
                    messages.error(request, "Category already exists.")
                else:
                    Category.objects.create(categoryname=categoryname)
                    messages.success(request, "Category added successfully.")
            else:
                messages.error(request, "Category name cannot be empty.")

        # EDIT category
        elif action == "edit" and category_id:
            category = get_object_or_404(Category, id=category_id)
            if categoryname:
                category.categoryname = categoryname
                category.save()
                messages.success(request, "Category updated successfully.")
            else:
                messages.error(request, "Category name cannot be empty.")

        # DELETE category
        elif action == "delete" and category_id:
            category = get_object_or_404(Category, id=category_id)
            category.delete()
            messages.success(request, "Category deleted successfully.")

        return redirect('admin_category')

    # Show all categories
    categories = Category.objects.all()
    return render(request, 'admin_category.html', {'categories': categories})





@login_required(login_url='login')
@never_cache
def admin_view_payments(request):

    payments = Payment.objects.select_related(
        'USERPROFILE',
        'GYM_OWNER'
    ).order_by('-payment_date')

    data = []

    for p in payments:
        data.append({
            'user': p.USERPROFILE.name,
            'gym': p.GYM_OWNER.name,
            'amount': p.amount,
            'date': p.payment_date,
            'status': p.status
        })

    return render(request, 'admin_payment.html', {'payments': data})



@login_required(login_url='login')
@never_cache
def admin_product(request):
    categories = Category.objects.all()
    products = Products.objects.all()

    if request.method == "POST":
        category_id = request.POST.get("category")
        title = request.POST.get("title")
        description = request.POST.get("description")
        url = request.POST.get("url")
        image = request.FILES.get("image")

        category = Category.objects.get(id=category_id)

        Products.objects.create(
            CATEGORY=category,
            title=title,
            description=description,
            url=url,
            image=image
        )
        messages.success(request, "Product added successfully")
        return redirect('admin_product')

    return render(request, "admin_product.html", {
        "categories": categories,
        "products": products
    })




@login_required(login_url='login')
@never_cache
def admin_editproduct(request, pk):
    product = get_object_or_404(Products, id=pk)
    categories = Category.objects.all()

    if request.method == "POST":
        product.CATEGORY_id = request.POST.get("category")
        product.title = request.POST.get("title")
        product.description = request.POST.get("description")
        product.url = request.POST.get("url")

        if request.FILES.get("image"):
            product.image = request.FILES.get("image")

        product.save()
        messages.success(request, "Product updated successfully")
        return redirect('admin_product')

    return render(request, "admin_editproduct.html", {
        "product": product,
        "categories": categories
    })


def admin_deleteproduct(request, pk):
    product = get_object_or_404(Products, id=pk)
    product.delete()
    messages.success(request, "Product deleted successfully")
    return redirect('admin_product')




from django.db.models import Sum
from django.utils import timezone
from django.contrib.admin.views.decorators import staff_member_required

@staff_member_required
def admin_gym_income_report(request):

    today = timezone.now()

    month = today.month
    year = today.year

    gyms = Gymowner.objects.filter(status="approved")

    report = []

    for g in gyms:

        # Monthly totals
        monthly_data = AdminMaintenance.objects.filter(
            GYM_OWNER=g,
            date__month=month,
            date__year=year
        ).aggregate(
            total=Sum('total_amount'),
            admin=Sum('admin_share'),
            gym=Sum('gym_share')
        )

        # Yearly totals
        yearly_data = AdminMaintenance.objects.filter(
            GYM_OWNER=g,
            date__year=year
        ).aggregate(
            total=Sum('total_amount'),
            admin=Sum('admin_share'),
            gym=Sum('gym_share')
        )


        report.append({

            'gym': g.name,
            'place': g.place,

            'monthly_total': monthly_data['total'] or 0,
            'monthly_admin': monthly_data['admin'] or 0,
            'monthly_gym': monthly_data['gym'] or 0,

            'yearly_total': yearly_data['total'] or 0,
            'yearly_admin': yearly_data['admin'] or 0,
            'yearly_gym': yearly_data['gym'] or 0,
        })


    return render(request,'admin_gym_income_report.html',{
        'report':report,
        'month':month,
        'year':year
    })


# ========= gym owner ==============================================================================================





@never_cache
@csrf_exempt
def gymowner_register(request):
    if request.method == "POST":
        name = request.POST.get('name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        place = request.POST.get('place')
        address = request.POST.get('address')
        description = request.POST.get('description')
        idproof = request.FILES.get('idproof')
        image = request.FILES.get('image')
        fees = request.POST.get('fees')
        username = request.POST.get('username')
        password = request.POST.get('password')

        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists')
            return redirect('gymowner_register')

        user = User.objects.create_user(username=username, password=password)

        group, created = Group.objects.get_or_create(name='gymowner')
        user.groups.add(group)

        Gymowner.objects.create(
            USER=user,
            name=name,
            email=email,
            phone=phone,
            place=place,
            address=address,
            description=description,
            idproof=idproof,
            image=image,
            fees=fees,
            status='pending'
        )

        messages.success(request, 'Registration Completed. Please wait for the approval.')
        return redirect('login')

    return render(request, 'gymowner_register.html')



@login_required(login_url='login')
@never_cache
def gymowner(request):
    return render(request,'gymowner.html')




@login_required(login_url='login')
@never_cache
def gymowner_view_profile(request):
    gymowner = Gymowner.objects.get(USER=request.user)
    return render(request, 'gymowner_view_profile.html', {'gymowner': gymowner})



@login_required(login_url='login')
@never_cache
def gymowner_edit_profile(request):
    gymowner = Gymowner.objects.get(USER=request.user)

    if request.method == "POST":
        gymowner.name = request.POST.get('name')
        gymowner.email = request.POST.get('email')
        gymowner.phone = request.POST.get('phone')
        gymowner.place = request.POST.get('place')
        gymowner.address = request.POST.get('address')
        gymowner.description = request.POST.get('description')
        gymowner.fees = request.POST.get('fees')

        if request.FILES.get('idproof'):
            gymowner.idproof = request.FILES.get('idproof')

        if request.FILES.get('image'):
            gymowner.image = request.FILES.get('image')

        gymowner.save()
        messages.success(request, "Profile updated successfully")
        return redirect('/gymowner_view_profile/')

    return render(request, 'gymowner_edit_profile.html', {'gymowner': gymowner})

@login_required(login_url='login')
@never_cache
def gymowner_trainer(request):

    gymowner_id = request.session.get('gymowner_id')
    tra = Trainer.objects.filter(GYM_OWNER_id=gymowner_id)
    trainer = None

    if 'delete' in request.GET:
        trainer_id = request.GET.get('delete')
        Trainer.objects.filter(id=trainer_id).delete()
        messages.success(request, 'Trainer deleted successfully')
        return redirect('gymowner_trainer')

    if 'edit' in request.GET:
        trainer_id = request.GET.get('edit')
        trainer = Trainer.objects.get(id=trainer_id)

    if request.method == "POST":

        trainer_id = request.POST.get('trainer_id')

        name = request.POST.get('name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        qualification = request.POST.get('qualification')
        experience = request.POST.get('experience')
        image = request.FILES.get('image')

        if trainer_id:
            t = Trainer.objects.get(id=trainer_id)
            t.name = name
            t.email = email
            t.phone = phone
            t.qualification = qualification
            t.experience = experience

            if image:
                t.image = image

            t.save()
            messages.success(request, 'Trainer updated successfully')
            return redirect('gymowner_trainer')

        username = request.POST.get('username')
        password = request.POST.get('password')

        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists')
            return redirect('gymowner_trainer')

        user = User.objects.create_user(username=username, password=password)

        group, created = Group.objects.get_or_create(name='trainer')
        user.groups.add(group)

        gymowner = Gymowner.objects.get(id=gymowner_id)

        Trainer.objects.create(
            GYM_OWNER=gymowner,
            USER=user,
            name=name,
            email=email,
            phone=phone,
            qualification=qualification,
            experience=experience,
            image=image
        )

        messages.success(request, 'Trainer added successfully')
        return redirect('gymowner_trainer')

    return render(request, 'gymowner_trainer.html', {'tra': tra, 'trainer': trainer})




@login_required(login_url='login')
@never_cache
def gym_add_workout_level(request):
    gym_owner = get_object_or_404(Gymowner, USER=request.user)
    workout_level = Workoutlevel.objects.filter(GYM_OWNER=gym_owner)

    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')

        Workoutlevel.objects.create(
            GYM_OWNER=gym_owner,
            title=title,
            description=description
        )

        messages.success(request, "Workout level added successfully.")
        return redirect('gym_add_workout_level')

    return render(request, 'gym_add_workout_level.html', {'workout_level': workout_level})


@login_required(login_url='login')
@never_cache
def gym_edit_workout_level(request, id):

    gym_owner = Gymowner.objects.get(USER=request.user)
    workout = Workoutlevel.objects.get(id=id, GYM_OWNER=gym_owner)

    if request.method == 'POST':
        workout.title = request.POST.get('title')
        workout.description = request.POST.get('description')
        workout.save()
        messages.success(request, "Workout level updated successfully.")
        return redirect('gym_add_workout_level')

    return render(request, 'gym_edit_workout_level.html', {'workout': workout})


@login_required(login_url='login')
@never_cache
def gym_delete_workout_level(request, id):
    gym_owner = get_object_or_404(Gymowner, USER=request.user)

    workout = get_object_or_404(Workoutlevel, id=id, GYM_OWNER=gym_owner)
    workout.delete()

    messages.success(request, "Workout level deleted successfully.")
    return redirect('gym_add_workout_level')







@login_required(login_url='login')
@never_cache
def gym_view_requests(request):
    gym_owner = get_object_or_404(Gymowner, USER=request.user)

    requests = Request.objects.filter(GYM_OWNER=gym_owner).order_by('-id')

    return render(request, 'gym_view_requests.html', {'requests': requests})



import smtplib
from django.shortcuts import redirect, get_object_or_404
from django.contrib import messages

@login_required(login_url='login')
@never_cache
def gym_accept_request(request, id):

    req = get_object_or_404(Request, id=id)

    req.status = "approved"
    req.save()

    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login("safedore3@gmail.com", "yqqlwlyqbfjtewam")

    to = req.USERPROFILE.email
    subject = "Gym Membership Approved"

    body = f"""
Hello {req.USERPROFILE.name},

Your gym membership request has been approved.

Now you can start using gym services.

Thank You.
"""

    msg = f"Subject: {subject}\n\n{body}"

    server.sendmail("safedore3@gmail.com", to, msg)

    server.quit()

    messages.success(request, "Member approved successfully")

    return redirect('gym_view_requests')



@login_required(login_url='login')
@never_cache
def gym_reject_request(request, id):
    req = get_object_or_404(Request, id=id)
    req.status = "rejected"
    req.save()

    messages.error(request, "Member rejected")
    return redirect('gym_view_requests')






@login_required(login_url='login')
@never_cache
def gymowner_payment_history(request):

    gym = Gymowner.objects.get(USER=request.user)

    payments = Payment.objects.filter(GYM_OWNER=gym).select_related('USERPROFILE').order_by('-payment_date')

    payment_data = []

    for p in payments:
        payment_data.append({
            'user': p.USERPROFILE.name,
            'amount': p.amount,
            'date': p.payment_date,
        })

    return render(request, 'gymowner_payment_history.html', {'payments': payment_data})


@login_required(login_url='login')
@never_cache
def gymowner_complaint(request):
    if request.method == "POST":
        complaint = request.POST.get("complaint")

        Complaints.objects.create(
            USER=request.user,
            complaint=complaint,
            reply="Pending",
            date=str(date.today())
        )
        return redirect("gymowner_complaint")

    complaints = Complaints.objects.filter(
        USER=request.user
    ).order_by("-id")

    return render(request, "gymowner_complaint.html", {
        "complaints": complaints
    })




@login_required(login_url='login')
@never_cache
def gymowner_view_feedback(request):

    gymowner = Gymowner.objects.get(USER=request.user)

    feedbacks = Feedback.objects.filter(
        TRAINER__GYM_OWNER=gymowner
    ).select_related('USER', 'TRAINER').order_by('-id')

    return render(request, 'gymowner_view_feedback.html', {'feedbacks': feedbacks})








@login_required(login_url='login')
@never_cache
def gymowner_send_notification(request):

    gym = Gymowner.objects.get(USER=request.user)

    success = False

    if request.method == "POST":
        title = request.POST['title']
        message = request.POST['message']
        target = request.POST['target']

        Notification.objects.create(
            GYM_OWNER=gym,
            title=title,
            message=message,
            target=target
        )

        success = True

    notifications = Notification.objects.filter(GYM_OWNER=gym).order_by('-id')

    return render(request, 'gymowner_send_notification.html', {
        'notifications': notifications,
        'success': success
    })



# ================= trainer=========================================================================================





@login_required(login_url='login')
@never_cache
def trainer(request):
    return render(request,'trainer.html')


@login_required(login_url='login')
@never_cache
def trainer_gymowner(request):
    # Get the trainer linked to the logged-in user
    trainer = Trainer.objects.get(USER=request.user)

    # Get the assigned gym owner
    gym = trainer.GYM_OWNER

    return render(request, 'trainer_gymowner.html', {
        'gym': gym
    })







@login_required(login_url='login')
@never_cache
def trainer_workoutlevel(request):
    trainer = get_object_or_404(Trainer, USER=request.user)
    workoutlevels = Workoutlevel.objects.filter(GYM_OWNER=trainer.GYM_OWNER)

    return render(request, 'trainer_workoutlevel.html', {
        'workoutlevels': workoutlevels
    })






@login_required(login_url='login')
@never_cache
def trainer_workoutroutine(request):

    trainer = get_object_or_404(Trainer, USER=request.user)
    workoutlevels = Workoutlevel.objects.filter(GYM_OWNER=trainer.GYM_OWNER)
    routines = Workoutroutine.objects.filter(TRAINER=trainer)

    if request.method == 'POST':
        level_id = request.POST.get('level')
        title = request.POST.get('title')
        description = request.POST.get('description')
        date = request.POST.get('date')   # ✅ added

        level = get_object_or_404(Workoutlevel, id=level_id, GYM_OWNER=trainer.GYM_OWNER)

        Workoutroutine.objects.create(
            TRAINER=trainer,
            WORKOUTLEVEL=level,
            title=title,
            description=description,
            date=date   # ✅ added
        )

        messages.success(request, "Routine added successfully")
        return redirect('trainer_workoutroutine')

    return render(request, 'trainer_workoutroutine.html', {
        'workoutlevels': workoutlevels,
        'routines': routines
    })


@login_required(login_url='login')
@never_cache
def trainer_edit_workoutroutine(request, id):

    trainer = get_object_or_404(Trainer, USER=request.user)
    routine = get_object_or_404(Workoutroutine, id=id, TRAINER=trainer)
    workoutlevels = Workoutlevel.objects.filter(GYM_OWNER=trainer.GYM_OWNER)

    if request.method == 'POST':
        level_id = request.POST.get('level')
        routine.title = request.POST.get('title')
        routine.description = request.POST.get('description')
        routine.date = request.POST.get('date')   # ✅ added
        routine.WORKOUTLEVEL = get_object_or_404(
            Workoutlevel,
            id=level_id,
            GYM_OWNER=trainer.GYM_OWNER
        )
        routine.save()

        messages.success(request, "Routine updated successfully")
        return redirect('trainer_workoutroutine')

    return render(request, 'trainer_edit_workoutroutine.html', {
        'routine': routine,
        'workoutlevels': workoutlevels
    })


@login_required(login_url='login')
def trainer_delete_workoutroutine(request, id):

    trainer = get_object_or_404(Trainer, USER=request.user)
    routine = get_object_or_404(Workoutroutine, id=id, TRAINER=trainer)
    routine.delete()

    messages.success(request, "Routine deleted successfully")
    return redirect('trainer_workoutroutine')







@login_required(login_url='login')
@never_cache
def trainer_dailyexerciseplan(request):

    trainer = get_object_or_404(Trainer, USER=request.user)
    workoutlevels = Workoutlevel.objects.filter(GYM_OWNER=trainer.GYM_OWNER)
    plans = Dailyexerciseplan.objects.filter(TRAINER=trainer)

    if request.method == 'POST':
        level_id = request.POST.get('level')
        plantext = request.POST.get('plantext')
        date = request.POST.get('date')

        level = get_object_or_404(Workoutlevel, id=level_id, GYM_OWNER=trainer.GYM_OWNER)

        Dailyexerciseplan.objects.create(
            TRAINER=trainer,
            WORKOUTLEVEL=level,
            plantext=plantext,
            date=date
        )

        messages.success(request, "Daily plan added successfully")
        return redirect('trainer_dailyexerciseplan')

    return render(request, 'trainer_dailyexerciseplan.html', {
        'workoutlevels': workoutlevels,
        'plans': plans
    })


@login_required(login_url='login')
@never_cache
def trainer_edit_dailyexerciseplan(request, id):

    trainer = get_object_or_404(Trainer, USER=request.user)
    plan = get_object_or_404(Dailyexerciseplan, id=id, TRAINER=trainer)
    workoutlevels = Workoutlevel.objects.filter(GYM_OWNER=trainer.GYM_OWNER)

    if request.method == 'POST':
        level_id = request.POST.get('level')
        plan.plantext = request.POST.get('plantext')
        plan.date = request.POST.get('date')
        plan.WORKOUTLEVEL = get_object_or_404(Workoutlevel, id=level_id, GYM_OWNER=trainer.GYM_OWNER)
        plan.save()

        messages.success(request, "Plan updated successfully")
        return redirect('trainer_dailyexerciseplan')

    return render(request, 'trainer_edit_dailyexerciseplan.html', {
        'plan': plan,
        'workoutlevels': workoutlevels
    })


@login_required(login_url='login')
def trainer_delete_dailyexerciseplan(request, id):

    trainer = get_object_or_404(Trainer, USER=request.user)
    plan = get_object_or_404(Dailyexerciseplan, id=id, TRAINER=trainer)
    plan.delete()

    messages.success(request, "Plan deleted successfully")
    return redirect('trainer_dailyexerciseplan')



@login_required(login_url='login')
@never_cache
def trainer_view_users(request):

    trainer = Trainer.objects.get(USER=request.user)
    gym = trainer.GYM_OWNER

    approved_users = Request.objects.filter(
        GYM_OWNER=gym,
        status="approved"
    ).select_related('USERPROFILE')

    return render(request, 'trainer_view_users.html', {'users': approved_users})


@login_required(login_url='login')
@never_cache
def trainer_complaint(request):
    if request.method == "POST":
        complaint = request.POST.get("complaint")

        Complaints.objects.create(
            USER=request.user,
            complaint=complaint,
            reply="Pending",
            date=str(date.today())
        )
        return redirect("trainer_complaint")

    complaints = Complaints.objects.filter(
        USER=request.user
    ).order_by("-id")

    return render(request, "trainer_complaint.html", {
        "complaints": complaints
    })





@login_required(login_url='login')
@never_cache
def trainer_view_feedback(request):
    trainer = Trainer.objects.get(USER=request.user)
    feedbacks = Feedback.objects.filter(TRAINER=trainer).order_by('-id')
    return render(request, 'trainer_view_feedback.html', {'feedbacks': feedbacks})



@login_required(login_url='login')
@never_cache
def trainer_view_notifications(request):

    trainer = Trainer.objects.get(USER=request.user)
    gym = trainer.GYM_OWNER

    notifications = Notification.objects.filter(
        GYM_OWNER=gym,
        target="trainers"
    ).order_by('-id')

    return render(request, 'trainer_view_notifications.html', {
        'notifications': notifications
    })






# =====================user========================================================================





@csrf_exempt
def user_register(request):
    if request.method == 'POST':
        name = request.POST['name']
        email = request.POST['email']
        phone = request.POST['phone']
        gender = request.POST['gender']
        age = request.POST['age']
        address = request.POST['address']
        place = request.POST['place']
        username = request.POST['username']
        password = request.POST['password']

        user = User.objects.create_user(username=username, password=password)
        group = Group.objects.get(name='user')
        user.groups.add(group)
        user.save()


        obj = Userprofile()
        obj.USER = user
        obj.name = name
        obj.email = email
        obj.phone = phone
        obj.gender = gender
        obj.age = age
        obj.address = address
        obj.place = place

        obj.save()

        return JsonResponse({'status': 'ok'})

    return JsonResponse({'status': 'error', 'message': 'Invalid request'}, status=400)



def user_login(request):
    username = request.POST['username']
    password = request.POST['password']

    user = authenticate(request, username=username, password=password)

    if user is not None:
        auth_login(request, user)


        if user.groups.filter(name='user').exists():
            return JsonResponse({'status': 'ok', 'lid': str(user.id)})


        else:
            return JsonResponse({'status': 'error'})


    else:
        return JsonResponse({'status': 'error'})



@csrf_exempt
def viewprofile(request):
    if request.method == 'POST':
        lid = request.POST.get('lid')

        user = Userprofile.objects.get(USER__id=lid)

        return JsonResponse({
            'status': 'ok',
            'username': user.USER.username,
            'name': user.name,
            'email': user.email,
            'phone': user.phone,
            'address': user.address,
            'place': user.place,
            'gender': user.gender,
            'age': user.age,
        })

    return JsonResponse({'status': 'error'})




@csrf_exempt
def editprofile(request):

    if request.method == 'POST':

        lid = request.POST.get('lid')

        user = User.objects.get(id=lid)
        profile = Userprofile.objects.get(USER=user)

        user.username = request.POST.get('username', user.username)

        password = request.POST.get('password')
        if password:
            user.set_password(password)

        user.save()

        profile.name = request.POST.get('name', profile.name)
        profile.email = request.POST.get('email', profile.email)
        profile.phone = request.POST.get('phone', profile.phone)
        profile.address = request.POST.get('address', profile.address)
        profile.gender = request.POST.get('gender', profile.gender)
        profile.age = request.POST.get('age', profile.age)
        profile.place = request.POST.get('place', profile.place)

        profile.save()

        return JsonResponse({'status': 'ok', 'message': 'Profile updated successfully'})

    return JsonResponse({'status': 'error'})





@csrf_exempt
def user_view_gym(request):
    if request.method == 'POST':
        lid = request.POST.get('lid')

        user = User.objects.get(id=lid)
        profile = Userprofile.objects.get(USER=user)

        gyms = Gymowner.objects.filter(status='approved')

        today = datetime.now()
        month = today.month
        year = today.year

        data = []

        for g in gyms:

            req = Request.objects.filter(GYM_OWNER=g, USERPROFILE=profile).first()

            if req:
                request_status = req.status
            else:
                request_status = "none"

            payment = Payment.objects.filter(
                USERPROFILE=profile,
                GYM_OWNER=g,
                payment_date__month=month,
                payment_date__year=year,
                status="Paid"
            ).first()

            if payment:
                payment_status = "paid"
            else:
                payment_status = "unpaid"

            if g.image:
                image_url = request.build_absolute_uri(g.image.url)
            else:
                image_url = ""

            data.append({
                'id': g.id,
                'name': g.name,
                'email': g.email,
                'phone': g.phone,
                'address': g.address,
                'description': g.description or "",
                'fees': str(g.fees) if g.fees else "0",
                'image': image_url,
                'request_status': request_status,
                'payment_status': payment_status
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})




from decimal import Decimal


@csrf_exempt
def user_pay_gym(request):

    if request.method == 'POST':

        lid = request.POST.get('lid')
        gym_id = request.POST.get('gym_id')

        user = User.objects.get(id=lid)
        profile = Userprofile.objects.get(USER=user)
        gym = Gymowner.objects.get(id=gym_id)

        now = timezone.now()

        # Check last payment
        last_payment = Payment.objects.filter(
            USERPROFILE=profile,
            GYM_OWNER=gym,
            status="Paid"
        ).order_by('-payment_date').first()

        # Active subscription check
        if last_payment:

            expiry_date = last_payment.payment_date + timedelta(days=30)

            if now <= expiry_date:
                return JsonResponse({'status': 'active'})


        # Create Payment
        payment = Payment.objects.create(
            USERPROFILE=profile,
            GYM_OWNER=gym,
            amount=gym.fees,
            status="Paid"
        )


        # Maintenance Calculation
        total = gym.fees

        admin_share = total * Decimal('0.10')
        gym_share   = total * Decimal('0.90')


        # Save Maintenance
        AdminMaintenance.objects.create(
            PAYMENT=payment,
            USERPROFILE=profile,
            GYM_OWNER=gym,
            total_amount=total,
            admin_share=admin_share,
            gym_share=gym_share
        )


        return JsonResponse({'status': 'ok'})



@csrf_exempt
def send_gym_request(request):
    if request.method == 'POST':

        lid = request.POST.get('lid')
        gym_id = request.POST.get('gym_id')
        description = request.POST.get('description')

        user = Userprofile.objects.get(USER=lid)
        gym = Gymowner.objects.get(id=gym_id)

        exist = Request.objects.filter(USERPROFILE=user, GYM_OWNER=gym).exists()
        if exist:
            return JsonResponse({'status': 'already'})

        obj = Request()
        obj.USERPROFILE = user
        obj.GYM_OWNER = gym
        obj.description = description
        obj.date = datetime.now().strftime("%Y-%m-%d")
        obj.status = "pending"
        obj.save()

        return JsonResponse({'status': 'ok'})

    return JsonResponse({'status': 'error'})




from django.utils import timezone
from datetime import timedelta

@csrf_exempt
def user_view_joined_gyms(request):
    if request.method == 'POST':
        lid = request.POST.get('lid')

        user = User.objects.get(id=lid)
        profile = Userprofile.objects.get(USER=user)

        today = timezone.now()

        reqs = Request.objects.filter(USERPROFILE=profile, status="approved")

        data = []

        for r in reqs:
            gym = r.GYM_OWNER

            payment = Payment.objects.filter(
                USERPROFILE=profile,
                GYM_OWNER=gym,
                status="Paid"
            ).order_by('-payment_date').first()

            if payment:
                expiry_date = payment.payment_date + timedelta(days=30)

                if today <= expiry_date:
                    pay_status = "paid"
                else:
                    pay_status = "expired"
            else:
                pay_status = "unpaid"

            if gym.image:
                image_url = request.build_absolute_uri(gym.image.url)
            else:
                image_url = ""

            data.append({
                'gym_id': gym.id,
                'name': gym.name,
                'email': gym.email,
                'phone': gym.phone,
                'address': gym.address,
                'fees': str(gym.fees) if gym.fees else "0",
                'image': image_url,
                'payment_status': pay_status
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})






@csrf_exempt
def user_view_gym_trainers(request):
    if request.method == 'POST':
        gym_id = request.POST.get('gym_id')
        lid = request.POST.get('lid')

        user = User.objects.get(id=lid)
        profile = Userprofile.objects.get(USER=user)
        gym = Gymowner.objects.get(id=gym_id)

        today = timezone.now()

        payment = Payment.objects.filter(
            USERPROFILE=profile,
            GYM_OWNER=gym,
            status="Paid"
        ).order_by('-payment_date').first()

        if payment:
            expiry_date = payment.payment_date + timedelta(days=30)

            if today > expiry_date:
                return JsonResponse({'status': 'expired'})
        else:
            return JsonResponse({'status': 'not_paid'})

        trainers = Trainer.objects.filter(GYM_OWNER=gym)

        data = []
        for t in trainers:

            if t.image:
                image_url = request.build_absolute_uri(t.image.url)
            else:
                image_url = ""

            data.append({
                'trainer_id': t.id,
                'name': t.name,
                'email': t.email,
                'phone': t.phone,
                'qualification': t.qualification,
                'experience': t.experience,
                'image': image_url,
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})



@csrf_exempt
def user_view_trainer_levels(request):
    if request.method == 'POST':
        trainer_id = request.POST.get('trainer_id')

        trainer = Trainer.objects.get(id=trainer_id)
        levels = Workoutlevel.objects.filter(GYM_OWNER=trainer.GYM_OWNER)

        data = []
        for l in levels:
            data.append({
                'level_id': l.id,
                'title': l.title,
                'description': l.description,
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})



@csrf_exempt
def user_view_trainer_workouts(request):

    if request.method == 'POST':

        trainer_id = request.POST.get('trainer_id')
        level_id = request.POST.get('level_id')
        day = request.POST.get('day')

        routines = Workoutroutine.objects.filter(
            TRAINER_id=trainer_id,
            WORKOUTLEVEL_id=level_id,
            date__iexact=day   # ✅ IMPORTANT
        )

        data = []

        for r in routines:

            data.append({
                'title': r.title,
                'description': r.description,
                'date': r.date,
                'level': r.WORKOUTLEVEL.title,
            })

        return JsonResponse({
            'status': 'ok',
            'data': data
        })

    return JsonResponse({'status': 'error'})

@csrf_exempt
def user_view_trainer_dailyplans(request):

    if request.method == 'POST':

        trainer_id = request.POST.get('trainer_id')
        level_id = request.POST.get('level_id')
        day = request.POST.get('day')

        plans = Dailyexerciseplan.objects.filter(
            TRAINER_id=trainer_id,
            WORKOUTLEVEL_id=level_id,
            date__iexact=day   # ✅ IMPORTANT
        )

        data = []

        for p in plans:

            data.append({
                'plantext': p.plantext,
                'date': p.date,
                'level': p.WORKOUTLEVEL.title,
            })

        return JsonResponse({
            'status': 'ok',
            'data': data
        })

    return JsonResponse({'status': 'error'})


@csrf_exempt
def user_view_products(request):
    if request.method == 'POST':

        products = Products.objects.all().order_by('-id')

        data = []

        for p in products:
            data.append({
                'id': p.id,
                'title': p.title,
                'description': p.description,
                'image': p.image.url if p.image else '',
                'url': p.url if p.url else '',
                'category': p.CATEGORY.categoryname
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})




@csrf_exempt
def user_send_complaint(request):
    if request.method == 'POST':
        user_id = request.POST['lid']
        user = User.objects.get(id=user_id)
        complaint_text = request.POST['complaint']
        complaint = Complaints.objects.create(
            USER=user,
            complaint=complaint_text,
            date=date.today(),
        )
        complaint.save()
        return JsonResponse({'status': 'ok', 'message': 'Complaint sent successfully'})
    else:
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})


@csrf_exempt
def user_view_complaints(request):
    if request.method == 'POST':
        lid = request.POST['lid']
        user = User.objects.get(id=lid)
        complaints = Complaints.objects.filter(USER=user)

        data = []
        for c in complaints:
            data.append({
                'id': c.id,
                'complaint': c.complaint,
                'date': c.date,
                'reply': c.reply or '',
            })

        return JsonResponse({'status': 'ok', 'data': data})
    else:
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})






from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from django.contrib.auth.models import User
from datetime import datetime
from .models import *

@csrf_exempt
def user_send_feedback(request):
    if request.method == 'POST':
        lid = request.POST.get('lid')
        trainer_id = request.POST.get('trainer_id')
        title = request.POST.get('title')
        feedback = request.POST.get('feedback')

        user = User.objects.get(id=lid)
        trainer = Trainer.objects.get(id=trainer_id)

        Feedback.objects.create(
            USER=user,
            TRAINER=trainer,
            title=title,
            feedback=feedback,
            date=datetime.now().strftime("%Y-%m-%d")
        )

        return JsonResponse({'status': 'ok'})

    return JsonResponse({'status': 'error'})


@csrf_exempt
def user_view_feedback(request):
    if request.method == 'POST':
        lid = request.POST.get('lid')

        user = User.objects.get(id=lid)

        feedbacks = Feedback.objects.filter(USER=user).order_by('-id')

        data = []
        for f in feedbacks:
            data.append({
                'id': f.id,
                'trainer': f.TRAINER.name,
                'gym': f.TRAINER.GYM_OWNER.name,
                'title': f.title,
                'feedback': f.feedback,
                'date': f.date,
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})


# =======================================================================


from .ai_medical import generate_ai_health_report
from .report_reader import extract_text


@csrf_exempt
def user_upload_medical_report(request):

    if request.method == 'POST':

        lid = request.POST['lid']
        title = request.POST['title']
        description = request.POST.get('description', '')
        file = request.FILES['file']

        user = Userprofile.objects.get(USER__id=lid)

        report = Medicalreport.objects.create(
            USERPROFILE=user,
            reporttitle=title,
            description=description,
            reportfile=file,
            date=date.today()
        )

        file_path = report.reportfile.path
        report_text = extract_text(file_path)

        if report_text.strip() == "":
            return JsonResponse({'status': 'error', 'message': 'Unable to read report'})

        summary_text, diet_text = generate_ai_health_report(report_text, description)

        Aisummary.objects.create(
            MEDICALREPORT=report,
            USERPROFILE=user,
            summary=summary_text,
            date=date.today()
        )

        Dietplans.objects.create(
            MEDICALREPORT=report,
            USERPROFILE=user,
            dietplan=diet_text,
            date=date.today()
        )

        return JsonResponse({
            'status': 'ok',
            'summary': summary_text,
            'dietplan': diet_text
        })

    return JsonResponse({'status': 'error'})



@csrf_exempt
def user_view_ai_summary(request):
    if request.method == 'POST':

        lid = request.POST['lid']

        summaries = Aisummary.objects.filter(USERPROFILE__USER__id=lid).order_by('-id')

        data = []
        for s in summaries:
            data.append({
                'title': s.MEDICALREPORT.reporttitle,
                'summary': s.summary,
                'date': s.date,
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})


@csrf_exempt
def user_view_dietplans(request):

    if request.method == 'POST':

        lid = request.POST['lid']

        plans = Dietplans.objects.filter(USERPROFILE__USER__id=lid).order_by('-id')

        data = []
        for p in plans:
            data.append({
                'title': p.MEDICALREPORT.reporttitle,
                'dietplan': p.dietplan,
                'date': p.date
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})


@csrf_exempt
def user_view_notifications(request):
    if request.method == 'POST':

        lid = request.POST['lid']

        user = User.objects.get(id=lid)
        profile = Userprofile.objects.get(USER=user)

        approved_gyms = Request.objects.filter(
            USERPROFILE=profile,
            status="approved"
        ).values_list('GYM_OWNER', flat=True)

        notifications = Notification.objects.filter(
            GYM_OWNER__in=approved_gyms,
            target="users"
        ).order_by('-id')

        data = []
        for n in notifications:
            data.append({
                'title': n.title,
                'message': n.message,
                'date': n.date.strftime("%d-%m-%Y %H:%M"),
                'gym': n.GYM_OWNER.name
            })

        return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})

