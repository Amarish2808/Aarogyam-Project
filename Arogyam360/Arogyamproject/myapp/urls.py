from django.urls import path
from myapp import views

urlpatterns = [

    path('',views.home,name='home'),
    path('login/',views.login,name='login'),
    path('logout_view/',views.logout_view, name='logout_view'),



# =========================admin==========================================================================================



    path('adminindex/', views.adminindex,name='adminindex'),

    path('admin_verifygymowner/', views.admin_verifygymowner,name='admin_verifygymowner'),
    path('admin_approvegymowner/<int:id>', views.admin_approvegymowner,name='admin_approvegymowner'),
    path('admin_rejectgymowner/<int:id>', views.admin_rejectgymowner,name='admin_rejectgymowner'),

    path('admin_complaint/', views.admin_complaint,name='admin_complaint'),
    path('admin_complaintreply/<int:id>', views.admin_complaintreply,name='admin_complaintreply'),

    path('admin_feedback/', views.admin_view_feedback,name='admin_feedback'),
    path('admin_category/', views.admin_category, name='admin_category'),

    path('admin_payment/', views.admin_view_payments, name='admin_payment'),
    path('admin_product/', views.admin_product, name='admin_product'),
    path('admin_editproduct/<int:pk>/', views.admin_editproduct, name='admin_editproduct'),
    path('admin_productdelete/<int:pk>/', views.admin_deleteproduct, name='admin_deleteproduct'),
    path('admin_gym_income_report/', views.admin_gym_income_report, name='admin_gym_income_report'),



# =========================gymowner===========================================================================================



    path('gymowner_register/', views.gymowner_register, name='gymowner_register'),
    path('gymowner_view_profile/', views.gymowner_view_profile, name='gymowner_view_profile'),
    path('gymowner_edit_profile/', views.gymowner_edit_profile, name='gymowner_edit_profile'),
    path('gymowner/', views.gymowner, name='gymowner'),
    path('gymowner_trainer/', views.gymowner_trainer, name='gymowner_trainer'),

    path('gym_add_workout_level/', views.gym_add_workout_level, name='gym_add_workout_level'),
    path('gym_delete_workout_level/<int:id>/', views.gym_delete_workout_level),
    path('gym_edit_workout_level/<int:id>/', views.gym_edit_workout_level),

    path('gym_view_requests/', views.gym_view_requests, name='gym_view_requests'),
    path('gym_accept_request/<int:id>/', views.gym_accept_request, name='gym_accept_request'),
    path('gym_reject_request/<int:id>/', views.gym_reject_request, name='gym_reject_request'),

    path('gymowner_payment_history/', views.gymowner_payment_history, name='gymowner_payment_history'),
    path('gymowner_complaint/', views.gymowner_complaint, name='gymowner_complaint'),
    path('gymowner_view_feedback/', views.gymowner_view_feedback, name='gymowner_view_feedback'),
    path('gymowner_send_notification/', views.gymowner_send_notification, name='gymowner_send_notification'),



# ========================trainer=============================================================================



    path('trainer/', views.trainer, name='trainer'),
    path('trainer_gymowner/', views.trainer_gymowner, name='trainer_gymowner'),

    path('trainer_workoutlevel/', views.trainer_workoutlevel, name='trainer_workoutlevel'),

    path('trainer_workoutroutine/', views.trainer_workoutroutine, name='trainer_workoutroutine'),
    path('trainer_edit_workoutroutine/<int:id>/', views.trainer_edit_workoutroutine,name='trainer_edit_workoutroutine'),
    path('trainer_delete_workoutroutine/<int:id>/', views.trainer_delete_workoutroutine,name='trainer_delete_workoutroutine'),

    path('trainer_dailyexerciseplan/', views.trainer_dailyexerciseplan, name='trainer_dailyexerciseplan'),
    path('trainer_edit_dailyexerciseplan/<int:id>/', views.trainer_edit_dailyexerciseplan, name='trainer_edit_dailyexerciseplan'),
    path('trainer_delete_dailyexerciseplan/<int:id>/', views.trainer_delete_dailyexerciseplan, name='trainer_delete_dailyexerciseplan'),

    path('trainer_view_users/', views.trainer_view_users, name='trainer_view_users'),

    path('trainer_complaint/', views.trainer_complaint, name='trainer_complaint'),
    path('trainer_view_feedback/', views.trainer_view_feedback, name='trainer_view_feedback'),
    path('trainer_view_notifications/', views.trainer_view_notifications, name='trainer_view_notifications'),
    # ======================user ========================================================================================



    path('user_register/', views.user_register, name='user_register'),
    path('user_login/', views.user_login, name='user_login'),
    path('viewprofile/', views.viewprofile, name='viewprofile'),
    path('editprofile/', views.editprofile, name='editprofile'),

    path('user_view_gym/', views.user_view_gym, name='user_view_gym'),
    path('send_gym_request/', views.send_gym_request,name='send_gym_request'),
    path('user_pay_gym/', views.user_pay_gym,name='user_pay_gym'),

    path('user_view_joined_gyms/', views.user_view_joined_gyms,name='user_view_joined_gyms'),
    path('user_view_gym_trainers/', views.user_view_gym_trainers,name='user_view_gym_trainers'),
    path('user_view_trainer_levels/', views.user_view_trainer_levels,name='user_view_trainer_levels'),
    path('user_view_trainer_workouts/', views.user_view_trainer_workouts,name='user_view_trainer_workouts'),
    path('user_view_trainer_dailyplans/', views.user_view_trainer_dailyplans,name='user_view_trainer_dailyplans'),

    path('user_view_products/', views.user_view_products,name='user_view_products'),
    path('user_send_complaint/', views.user_send_complaint, name='user_send_complaint'),
    path('user_view_complaints/', views.user_view_complaints, name='user_view_complaints'),

    path('user_send_feedback/', views.user_send_feedback, name='user_send_feedback'),
    path('user_view_feedback/', views.user_view_feedback, name='user_send_feedback'),

    path('user_upload_medical_report/', views.user_upload_medical_report, name='user_upload_medical_report'),
    path('user_view_ai_summary/', views.user_view_ai_summary, name='user_view_ai_summary'),
    path('user_view_dietplans/', views.user_view_dietplans, name='user_view_dietplans'),

    path('user_view_notifications/', views.user_view_notifications, name='user_view_notifications'),



]
