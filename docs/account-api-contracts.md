# نطاق الهاتف والاسم وحذف الحساب

هذا الملف يصف ما ثبته المصدر وما بقي معلقاً، ولا يثبت استجابة السيرفر الفعلية.
لم يُرسل OTP ولم يُحذف حساب ولم يُنشأ طلب أثناء التنفيذ.

## المصادقة: login مثبت من Postman، وverify قيد الفحص

أكد صاحب التطبيق في مرحلة فحص المصادقة أن `POST /api/login` يستقبل
`phone_number` وحده ويرسل OTP للرقم الموجود والجديد ويعالج التسجيل داخلياً.
أصبح `PhoneAuthContract.confirmed = true`. لا ترسل الشاشة name ولا تستدعي register.
أكدت صورة Postman اللاحقة أن الطلب multipart/form-data، ورد النجاح HTTP 200
وmessage «تم إرسال رمز التحقق بنجاح. يرجى التحقق.». أصبح loginReplyConfirmed
يساوي true، واستخدم login وحده MultipartRequest مع boundary تلقائي. لا يشترط
رد إرسال الرمز توكن أو user أو success؛ تفحص بيانات الجلسة عند verify لاحقاً.

إعادة الإرسال السابقة تستخدم login نفسه، لكن دلالتها وحدودها لم تؤكد بعد؛
لذلك `resendConfirmed = false` بشكل مستقل. لا تختبر قبل تنسيق محاولة واحدة.
التفاصيل التشغيلية في `docs/auth-api-check.md`.
الرابط القديم `/register` يفتح الشاشة الموحدة نفسها.

العقد الذي كان العميل يتوقعه من verify هو `token` و`user.id`، مع حقول
اختيارية منها `user.name`. لا يوجد مسار قراءة المستخدم الحالي موثق في المشروع.

## الاسم

المعلومة السابقة كانت `PUT /api/user/profile` بتوكن JSON وbody وحيد
`{"name":"..."}`. الفحص الحي اللاحق أعاد HTTP 405، وصورة الرد تؤكد أن هذا
المسار يقبل GET وHEAD فقط. لذلك عقد تحديث الاسم غير مثبت، ويلزم مسار وطريقة
التحديث الصحيحتان من الباك إند أو طلب Postman ناجح قبل تعديل الطلب أو تكراره.
التحقق المحلي للاسم الجديد يتطلب ثلاثة أحرف على الأقل بعد trim.

لعدم وجود نموذج رد فعلي، adapter محافظ: لا يُكمل الاسم إلا مع HTTP 200
وJSON يعيد الاسم المطابق في `user.name` أو `name`، دون خطأ صريح. إذا أعيد
id يجب أن يطابق الحساب. هذه صيغ مدعومة محلياً وليست ادعاءً بأن السيرفر يعيدها.
رسالة نجاح وحدها أو 204 لتعديل الاسم لا تكفي لإثبات الاسم المحفوظ حالياً.
يجب تعديل decoder عند وصول نموذج الرد الفعلي، دون تخمين.

الاسم النصي غير الفارغ الموجود للحساب لا يُطلب مجدداً، حتى لو كان أقصر من
ثلاثة أحرف؛ حد الثلاثة أحرف يخص تسجيل اسم جديد. غياب name أو null أو النص
الفارغ في بيانات المستخدم المتحقق من هويته يفتح ديالوغ الإكمال. النوع غير
الصالح أو بيانات حساب آخر لا تؤكد غياب الاسم، ولا تسمح باستبداله.

تُحفظ نسخة الاسم التي أعادها الخادم مع id الحساب، لاستئناف الحالة بعد إعادة
التشغيل. لا يُعتمد `user_name` القديم أو علم محلي بمفرده. هذه آخر نسخة موثوقة
وصلت للعميل، وليست إعادة جلب مباشرة؛ تحديث الاسم من جهاز آخر والتحقق من جلسات
قديمة بلا نسخة موثوقة يحتاجان مسار قراءة المستخدم الحالي من الباك إند.

حارس الاسم مطبق داخل إجرائي إنشاء طلب المتاجر والتوصيل الخارجي. لا يتغير
التسعير أو الدفع أو دورة التأكيد والإلغاء. يجب فرض الشرط على السيرفر أيضاً.

## حذف الحساب

المؤكد من صاحب الطلب: `DELETE /api/user/account` مع التوكن وبدون body.
صيغة رد النجاح غير معطاة. يدعم adapter تأكيد HTTP 204 بلا body فقط؛ هذا
اعتماد لدلالة HTTP 204، وليس إثباتاً أن السيرفر يستخدمه. لا تعتبر ردود 200
أو 202 أو رسائل عشوائية نجاحاً قبل توثيقها. رد 401 انتهاء جلسة وليس حذفاً.
أخطاء JSON تعرض message أو errors.name عند توفرها.

بعد التأكيد تُزال بيانات الجلسة والتخزين الخاص (السلة والملاحظات والعناوين
والمفضلة والإشعارات والطلب النشط محلياً)، وتُستبدل المتحكمات التي تحتفظ بها،
وتُمسح الشاشات السابقة. يُحتفظ باللغة وإتمام التعريف فقط. يجري فك رمز الجهاز
بأفضل جهد؛ فشله لا يمنع التنظيف. لا تُرسل أي إلغاءات طلبات.

يجب أن يزيل الباك إند ارتباط أجهزة الحساب عند الحذف، لأن توكن المستخدم قد
يصبح غير صالح قبل طلب فك الارتباط. منع وصول Push للحساب القديم بعد تبديل
الحساب لا يمكن ضمانه من العميل وحده دون عقد هوية للمستلم.

## المطلوب من الباك إند

- عقد OTP موحد للهاتف فقط، للأرقام القديمة والجديدة، وإعادة الإرسال.
- نماذج verify، خصوصاً تمثيل الحساب بلا اسم وهل user.name موجود دائماً.
- مسار قراءة الملف الحالي بالتوكن ونموذج رده.
- ردود profile الناجحة و401 و422 وأخطاء التحقق.
- رد حذف الحساب الناجح، ورفض الطلب النشط، ودلالة الحذف واحتفاظ البيانات.
- فرض اكتمال الاسم في إنشاء الطلبين، وتسوية أجهزة الإشعارات عند الحذف.

## الملفات المعدلة أو المضافة في هذا النطاق

- docs/account-api-contracts.md
- lib/binding/my_binding.dart
- lib/controller/auth/login/login_controller.dart
- lib/controller/auth/otp/otp_controller.dart
- lib/controller/external_delivery/external_delivery_controller.dart
- lib/controller/favorites/favorites_controller.dart
- lib/controller/notifications/notifications_controller.dart
- lib/controller/order/order_controller.dart
- lib/controller/orderHistoory/external_orders_controller.dart
- lib/controller/orderHistoory/order_his_controller.dart
- lib/controller/profile/account_controller.dart
- lib/controller/wallet/wallet_controller.dart
- lib/controller/wallet/wallet_payment_mixin.dart
- lib/core/class/crud.dart
- lib/core/constant/phone_auth_contract.dart
- lib/core/constant/routes/app_routes.dart
- lib/core/services/account_local_cleanup.dart
- lib/core/services/session_service.dart
- lib/core/shared/notifications/notification_api.dart
- lib/core/shared/notifications/notification_inbox.dart
- lib/data/datasource/remot/account_data.dart
- lib/data/datasource/remot/login_data.dart
- lib/data/datasource/remot/otp_data.dart
- lib/link_api.dart
- lib/view/auth/login/login_view.dart
- lib/view/auth/register/register_view.dart
- lib/view/auth/widgets/account_dialogs.dart
- lib/view/profile/profile_view.dart
- test/account_flow_test.dart

ملف lib/generated/l10n.dart تعديل سابق للمستخدم، ولم يدخل في هذا النطاق.
