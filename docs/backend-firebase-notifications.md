# إشعارات شبيك لبيك — تنفيذ Laravel

التطبيق جاهز وينادي المسارات أدناه. هذا الملف لمبرمج Laravel: الملفات التي ينشئها، والجداول، والمسارات، وخدمة الإرسال من لوحة الأدمن.

الهوية المعتمدة:

- Firebase project id: `shbeek-lbeek2`
- Android package: `com.shbeeklbeek.app`
- أساس الـ API: `https://shbeeklbeek.com/api`
- توكن المستخدم هو المفتاح `token` الراجع من `POST /api/verify`، ويصل في الهيدر `Authorization: Bearer {token}`

لا تستخدم مشروع Firebase القديم. ملف `google-services.json` خاص بأندرويد. السيرفر يحتاج Service Account JSON من مشروع `shbeek-lbeek2` فقط. لا ترفع ملف الحساب إلى Git ولا تضعه داخل مشروع Flutter.

إذا حماية الـ API الحالية ليست `auth:sanctum`، استبدل اسم الميدلوير في `routes/api.php` بالميدلوير المستخدم أصلاً على مسارات مثل `/api/my_order`.

---

## 1. التجهيز

من Firebase Console لمشروع `shbeek-lbeek2`: Project settings ثم Service accounts ثم Generate new private key.

ضع الملف هنا وتأكد أنه داخل `.gitignore`:

```text
storage/app/firebase-auth.json
```

فعّل Cloud Messaging API (HTTP v1) على نفس مشروع Google Cloud. لا تستخدم Legacy server key.

```bash
composer require kreait/laravel-firebase
php artisan vendor:publish --provider="Kreait\Laravel\Firebase\ServiceProvider" --tag=config
```

في `.env`:

```env
FIREBASE_CREDENTIALS=storage/app/firebase-auth.json
```

ثم:

```bash
php artisan config:clear
```

---

## 2. ما يناديه التطبيق

كل الطلبات JSON، ومعها `Accept: application/json` وتوكن المستخدم. النجاح أي حالة `200–299`. حالة `401` تخرج المستخدم من التطبيق.

| الطلب | الوظيفة |
|---|---|
| `POST /api/device-tokens` | حفظ رمز الجهاز بعد الدخول وعند تغيّر الرمز |
| `POST /api/device-tokens/remove` | حذف الرمز عند تسجيل الخروج |
| `GET /api/notifications` | قائمة إشعارات المستخدم |
| `POST /api/notifications/{id}/mark-as-read` | تعليم واحد كمقروء |
| `POST /api/notifications/mark-all-as-read` | تعليم الكل |
| `DELETE /api/notifications/{id}` | حذف إشعار المستخدم |

الضيف لا يرسل رمز جهاز. الإشعار المخصص يصل لمن سجّل دخوله مرة على الأقل وصار له صف في `device_tokens`.

التطبيق يخفي الإشعار بعد 7 أيام من `created_at`، ولا يعيد إظهار `id` حذفه المستخدم من الجهاز.

جدول Laravel الافتراضي `notifications` (uuid + notifiable) لا يطابق هذا العقد. استخدم الجدول `user_notifications` حتى لا يصطدم مع إشعارات Laravel الداخلية. مسار الـ API يبقى `/api/notifications`.

---

## 3. الهجرة

```bash
php artisan make:migration create_device_tokens_table
php artisan make:migration create_user_notifications_table
```

`database/migrations/xxxx_xx_xx_create_device_tokens_table.php`

```php
public function up(): void
{
    Schema::create('device_tokens', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained()->cascadeOnDelete();
        $table->string('fcm_token')->unique();
        $table->string('platform', 20);
        $table->timestamps();

        $table->index('user_id');
    });
}
```

`database/migrations/xxxx_xx_xx_create_user_notifications_table.php`

```php
public function up(): void
{
    Schema::create('user_notifications', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained()->cascadeOnDelete();
        $table->string('type', 50)->default('admin');
        $table->json('data');
        $table->timestamp('read_at')->nullable();
        $table->timestamps();

        $table->index(['user_id', 'created_at']);
    });
}
```

```bash
php artisan migrate
```

---

## 4. الموديلات

`app/Models/DeviceToken.php`

```php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DeviceToken extends Model
{
    protected $fillable = ['user_id', 'fcm_token', 'platform'];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

`app/Models/UserNotification.php`

```php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserNotification extends Model
{
    protected $fillable = ['user_id', 'type', 'data', 'read_at'];

    protected $casts = [
        'data' => 'array',
        'read_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

في `app/Models/User.php` أضف:

```php
public function deviceTokens()
{
    return $this->hasMany(\App\Models\DeviceToken::class);
}

public function userNotifications()
{
    return $this->hasMany(\App\Models\UserNotification::class);
}
```

---

## 5. المسارات

في `routes/api.php`. مجموعة المستخدم تأخذ نفس ميدلوير باقي التطبيق. مجموعة الأدمن تأخذ ميدلوير الأدمن الموجود عندكم.

```php
use App\Http\Controllers\Api\DeviceTokenController;
use App\Http\Controllers\Api\UserNotificationController;
use App\Http\Controllers\Admin\AdminNotificationController;

Route::middleware('auth:sanctum')->group(function () {
    Route::post('device-tokens', [DeviceTokenController::class, 'store']);
    Route::post('device-tokens/remove', [DeviceTokenController::class, 'destroy']);

    Route::get('notifications', [UserNotificationController::class, 'index']);
    Route::post('notifications/{notification}/mark-as-read', [UserNotificationController::class, 'markAsRead']);
    Route::post('notifications/mark-all-as-read', [UserNotificationController::class, 'markAllAsRead']);
    Route::delete('notifications/{notification}', [UserNotificationController::class, 'destroy']);
});

Route::middleware(['auth:sanctum', 'admin'])->prefix('admin')->group(function () {
    Route::post('notifications', [AdminNotificationController::class, 'store']);
});
```

عرّف `{notification}` على موديل `UserNotification` حتى لا يلتبس مع جدول Laravel:

```php
// RouteServiceProvider أو AppServiceProvider::boot
Route::model('notification', \App\Models\UserNotification::class);
```

`mark-all-as-read` سطر ثابت، ضعه قبل مسار `{notification}` إذا جمعتهما بـ `apiResource`. بالترتيب أعلاه Laravel لا يخلطهما.

---

## 6. رموز الأجهزة

`app/Http/Requests/StoreDeviceTokenRequest.php`

```php
public function rules(): array
{
    return [
        'fcm_token' => ['required', 'string', 'max:512'],
        'platform' => ['required', 'in:android,ios'],
    ];
}
```

`app/Http/Requests/RemoveDeviceTokenRequest.php`

```php
public function rules(): array
{
    return [
        'fcm_token' => ['required', 'string', 'max:512'],
    ];
}
```

`app/Http/Controllers/Api/DeviceTokenController.php`

```php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\RemoveDeviceTokenRequest;
use App\Http\Requests\StoreDeviceTokenRequest;
use App\Models\DeviceToken;
use Illuminate\Http\JsonResponse;

class DeviceTokenController extends Controller
{
    public function store(StoreDeviceTokenRequest $request): JsonResponse
    {
        $token = $request->string('fcm_token')->toString();

        DeviceToken::updateOrCreate(
            ['fcm_token' => $token],
            [
                'user_id' => $request->user()->id,
                'platform' => $request->string('platform')->toString(),
            ],
        );

        return response()->json(['message' => 'saved']);
    }

    public function destroy(RemoveDeviceTokenRequest $request): JsonResponse
    {
        DeviceToken::query()
            ->where('user_id', $request->user()->id)
            ->where('fcm_token', $request->string('fcm_token')->toString())
            ->delete();

        return response()->json(['message' => 'removed']);
    }
}
```

`updateOrCreate` على `fcm_token` ينقل الجهاز للحساب الجديد إذا سجّل شخص آخر من نفس الجوال.

التطبيق يرسل `platform` بقيمة `android` أو `ios` فقط.

---

## 7. قراءة الإشعارات من التطبيق

جذر الرد لازم يكون المفتاح `notifications` مباشرة. لا تلفّ الرد داخل `data`.

`app/Http/Controllers/Api/UserNotificationController.php`

```php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserNotificationController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $items = UserNotification::query()
            ->where('user_id', $request->user()->id)
            ->where('created_at', '>=', now()->subDays(7))
            ->latest()
            ->get()
            ->map(fn (UserNotification $item) => $this->payload($item));

        return response()->json(['notifications' => $items]);
    }

    public function markAsRead(Request $request, UserNotification $notification): JsonResponse
    {
        $this->authorizeOwner($request, $notification);
        $notification->forceFill(['read_at' => $notification->read_at ?? now()])->save();

        return response()->json(['message' => 'read']);
    }

    public function markAllAsRead(Request $request): JsonResponse
    {
        UserNotification::query()
            ->where('user_id', $request->user()->id)
            ->whereNull('read_at')
            ->update(['read_at' => now()]);

        return response()->json(['message' => 'read']);
    }

    public function destroy(Request $request, UserNotification $notification): JsonResponse
    {
        $this->authorizeOwner($request, $notification);
        $notification->delete();

        return response()->json(['message' => 'deleted']);
    }

    private function authorizeOwner(Request $request, UserNotification $notification): void
    {
        abort_unless($notification->user_id === $request->user()->id, 404);
    }

    private function payload(UserNotification $item): array
    {
        $data = $item->data ?? [];
        $data['notification_id'] = (string) $item->id;

        return [
            'id' => $item->id,
            'type' => $item->type,
            'data' => $data,
            'read_at' => $item->read_at?->toISOString(),
            'created_at' => $item->created_at?->toISOString(),
        ];
    }
}
```

`read_at: null` تعني غير مقروء. أي تاريخ يعني مقروء. `created_at` بصيغة ISO 8601.

مفاتيح `data` التي يفهمها التطبيق:

| screen | الصفحة | الحقول |
|---|---|---|
| `order` | تفاصيل الطلب | `order_id` |
| `product` | صفحة المنتج | `product_id` ويفضّل `store_id` |
| `store` | صفحة المتجر | `store_id` |
| `cart` | السلة | — |
| `wallet` | المحفظة | — |
| `home` | الرئيسية | — |
| فارغ | صفحة الإشعارات | — |

العنوان في `data.title` والنص في `data.message`. التطبيق يقبل أيضاً `body` إذا غاب `message`.

---

## 8. إرسال Firebase

`app/Services/Notifications/FcmService.php`

```php
namespace App\Services\Notifications;

use App\Models\DeviceToken;
use App\Models\UserNotification;
use Kreait\Firebase\Contract\Messaging;
use Kreait\Firebase\Messaging\AndroidConfig;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FcmService
{
    public function __construct(private Messaging $messaging) {}

    public function send(UserNotification $notification): int
    {
        $tokens = DeviceToken::query()
            ->where('user_id', $notification->user_id)
            ->pluck('fcm_token')
            ->all();

        if ($tokens === []) {
            return 0;
        }

        $stored = $notification->data ?? [];
        $title = (string) ($stored['title'] ?? 'إشعار');
        $body = (string) ($stored['message'] ?? $stored['body'] ?? '');

        $data = [
            'title' => $title,
            'message' => $body,
            'type' => (string) $notification->type,
            'notification_id' => (string) $notification->id,
        ];

        foreach (['screen', 'order_id', 'product_id', 'store_id'] as $key) {
            if (!empty($stored[$key])) {
                $data[$key] = (string) $stored[$key];
            }
        }

        $message = CloudMessage::new()
            ->withNotification(Notification::create($title, $body))
            ->withData($data)
            ->withAndroidConfig(AndroidConfig::fromArray([
                'priority' => 'high',
                'notification' => [
                    'channel_id' => 'high_importance_channel',
                    'sound' => 'default',
                ],
            ]));

        $sent = 0;

        foreach (array_chunk($tokens, 500) as $chunk) {
            $report = $this->messaging->sendMulticast($message, $chunk);
            $sent += $report->successes()->count();

            $dead = array_merge($report->invalidTokens(), $report->unknownTokens());
            if ($dead !== []) {
                DeviceToken::query()->whereIn('fcm_token', $dead)->delete();
            }
        }

        return $sent;
    }
}
```

كل قيم `data` نصوص. Firebase يرفض الأرقام داخل `data`. اسم قناة أندرويد في التطبيق `high_importance_channel`. بلوك `notification` لازم يبقى حتى يظهر الإشعار والتطبيق مغلق. `notification_id` يساوي `user_notifications.id`.

---

## 9. لوحة الأدمن

حقول النموذج:

- `title` مطلوب
- `message` مطلوب
- `audience` قيمته `all` أو `user`
- `user_id` مطلوب عندما `audience=user`
- `screen` اختيارية: `order` أو `product` أو `store` أو `cart` أو `wallet` أو `home`
- `order_id` عندما الوجهة طلب
- `product_id` وعادة `store_id` عندما الوجهة منتج
- `store_id` عندما الوجهة متجر

`app/Http/Requests/Admin/StoreAdminNotificationRequest.php`

```php
public function rules(): array
{
    return [
        'title' => ['required', 'string', 'max:120'],
        'message' => ['required', 'string', 'max:500'],
        'audience' => ['required', 'in:all,user'],
        'user_id' => ['required_if:audience,user', 'nullable', 'exists:users,id'],
        'screen' => ['nullable', 'in:order,product,store,cart,wallet,home'],
        'order_id' => ['nullable', 'integer', 'required_if:screen,order'],
        'product_id' => ['nullable', 'integer', 'required_if:screen,product'],
        'store_id' => ['nullable', 'integer', 'required_if:screen,store'],
    ];
}
```

`app/Services/Notifications/AdminNotificationService.php`

```php
namespace App\Services\Notifications;

use App\Models\DeviceToken;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Support\Facades\DB;

class AdminNotificationService
{
    public function __construct(private FcmService $fcm) {}

    public function create(array $input): array
    {
        $userIds = $input['audience'] === 'user'
            ? [(int) $input['user_id']]
            : DeviceToken::query()->distinct()->pluck('user_id')->all();

        $created = 0;
        $pushed = 0;

        foreach ($userIds as $userId) {
            $notification = DB::transaction(function () use ($input, $userId) {
                $row = UserNotification::create([
                    'user_id' => $userId,
                    'type' => 'admin',
                    'data' => $this->data($input, null),
                ]);

                $row->update([
                    'data' => $this->data($input, $row->id),
                ]);

                return $row->fresh();
            });

            $created++;
            $pushed += $this->fcm->send($notification);
        }

        return ['created' => $created, 'pushed_devices' => $pushed];
    }

    private function data(array $input, ?int $id): array
    {
        $data = [
            'title' => $input['title'],
            'message' => $input['message'],
        ];

        if (!empty($input['screen'])) {
            $data['screen'] = $input['screen'];
        }
        if (!empty($input['order_id'])) {
            $data['order_id'] = (string) $input['order_id'];
        }
        if (!empty($input['product_id'])) {
            $data['product_id'] = (string) $input['product_id'];
        }
        if (!empty($input['store_id'])) {
            $data['store_id'] = (string) $input['store_id'];
        }
        if ($id !== null) {
            $data['notification_id'] = (string) $id;
        }

        return $data;
    }
}
```

جمهور `all` هو المستخدمون الذين لديهم رمز جهاز، وليس كل صفوف `users`. من لم يفتح التطبيق بعد الدخول لا يملك رمزاً.

لكل مستخدم صف خاص. لا تنشئ صفاً واحداً للكل، لأن `read_at` والحذف خاصان بكل شخص، و`notification_id` يختلف من شخص لآخر.

`app/Http/Controllers/Admin/AdminNotificationController.php`

```php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreAdminNotificationRequest;
use App\Services\Notifications\AdminNotificationService;
use Illuminate\Http\JsonResponse;

class AdminNotificationController extends Controller
{
    public function store(
        StoreAdminNotificationRequest $request,
        AdminNotificationService $service,
    ): JsonResponse {
        return response()->json($service->create($request->validated()));
    }
}
```

إذا كان حفظ «الكل» ثقيلاً، انقل حلقة الإرسال إلى Job بعد إنشاء الصفوف:

```php
dispatch(new \App\Jobs\SendUserNotificationJob($notification->id));
```

والـ Job يستدعي `FcmService::send`. إنشاء الصف يبقى داخل الطلب حتى يظهر الإشعار في `GET` حتى لو تأخر الدفع.

مثال جسم اللوحة:

```json
{
  "title": "عرض جديد",
  "message": "خصم على البيتزا",
  "audience": "user",
  "user_id": 8,
  "screen": "product",
  "product_id": 123,
  "store_id": 4
}
```

الرد:

```json
{ "created": 1, "pushed_devices": 1 }
```

فشل بعض الأجهزة لا يلغي الصف. المستخدم يراه عند فتح صفحة الإشعارات.

---

## 10. إشعار تغيّر حالة الطلب

من نفس المكان الذي يحدّث حالة الطلب، بعد الحفظ:

```php
$notification = UserNotification::create([
    'user_id' => $order->user_id,
    'type' => 'order_status',
    'data' => [
        'title' => 'تحديث الطلب',
        'message' => 'تغيرت حالة طلبك',
        'screen' => 'order',
        'order_id' => (string) $order->id,
    ],
]);

$notification->update([
    'data' => array_merge($notification->data, [
        'notification_id' => (string) $notification->id,
    ]),
]);

app(\App\Services\Notifications\FcmService::class)->send($notification->fresh());
```

`screen=order` مع `order_id` يفتح تفاصيل ذلك الطلب في التطبيق.

---

## 11. حذف الأقدم من أسبوع

`app/Console/Commands/PruneUserNotifications.php`

```php
protected $signature = 'notifications:prune';

public function handle(): int
{
    \App\Models\UserNotification::query()
        ->where('created_at', '<', now()->subDays(7))
        ->delete();

    return self::SUCCESS;
}
```

Laravel 11 في `routes/console.php`:

```php
use Illuminate\Support\Facades\Schedule;

Schedule::command('notifications:prune')->daily();
```

Laravel 10 في `app/Console/Kernel.php`:

```php
$schedule->command('notifications:prune')->daily();
```

تأكد أن Cron يشغّل `php artisan schedule:run` كل دقيقة.

الرموز التالفة تُحذف داخل `FcmService` عند رد `invalidTokens` أو `unknownTokens`. لا تنتظر مهمة التنظيف.

---

## 12. تجربة القبول

1. سجّل الدخول من التطبيق وتأكد من صف جديد في `device_tokens` لنفس `user_id`.
2. أرسل من لوحة الأدمن إلى `audience=user`.
3. يظهر صف في `user_notifications` و`data.notification_id` يساوي `id`.
4. يصل الإشعار والتطبيق مفتوح، وفي الخلفية، ومغلق.
5. `GET /api/notifications` يرجع `{ "notifications": [ ... ] }` من الجذر.
6. فتح الإشعار يضرب `mark-as-read` ويملأ `read_at`.
7. تسجيل الخروج يضرب `device-tokens/remove` ويحذف الرمز.
8. رمز Firebase غير الصالح يُحذف من `device_tokens` بعد الإرسال.

أخطاء توقف الربط:

- Service Account من المشروع القديم.
- وضع أرقام غير محوّلة إلى نص داخل `data` في رسالة Firebase.
- رد القائمة بالشكل `{ "data": { "notifications": [] } }`.
- صف واحد مشترك بين كل المستخدمين.
- إرسال بدون بلوك `notification`، فلا يظهر شيء والجهاز مقفل.
- استخدام `google-services.json` بدل Service Account.
