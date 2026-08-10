# Auth Flow + Advanced State (Mock JWT Auth)

Flutter tətbiqi — login/registration ekranları, qorunan naviqasiya, Bloc/Cubit ilə advanced state management və Geolocator ilə cihaz funksiyası (location) inteqrasiyası.

## Xüsusiyyətlər

- **Login / Registration** — form validasiyası ilə (email, password, name, confirm password)
- **Mock JWT Authentication** — in-memory backend, saxta JWT token generasiyası, şəbəkə xətası simulyasiyası
- **Session persistence** — `shared_preferences` ilə token/user saxlanılır, tətbiq yenidən açılanda sessiya bərpa olunur
- **Route protection** — `go_router` ilə, `AuthCubit` state-inə əsaslanan `redirect` məntiqi
- **Splash / async auth check** — tətbiq açılışında sessiya yoxlanılana qədər UI göstərilmir (splash screen)
- **Advanced state management** — `flutter_bloc` (Cubit) ilə ayrılmış: `AuthCubit` (qlobal sessiya), `LoginCubit`, `RegisterCubit`, `LocationCubit`
- **Location (Geolocator + Geocoding)** — cari mövqeyi əldə etmə, permission idarəetməsi (denied, deniedForever, service disabled) və "Open Settings" yönləndirməsi
- **Logout + error handling** — səhv şifrə, mövcud email, şəbəkə xətası kimi hallar `SnackBar` ilə istifadəçiyə göstərilir

## Arxitektura

Clean Architecture prinsipinə əsaslanır:

```
lib/
├── app/                    # App widget, MaterialApp.router
├── core/
│   ├── di/                 # get_it ilə dependency injection
│   ├── network/             # Dio client
│   ├── router/              # go_router konfiqurasiyası
│   ├── theme/
│   ├── utils/                # Validators
│   └── widgets/              # Ortaq UI komponentləri
└── features/
    ├── auth/
    │   ├── cubit/            # AuthCubit, LoginCubit, RegisterCubit
    │   ├── data/              # Repository implementasiyaları, model-lər
    │   ├── domain/            # Entity-lər, exception-lar
    │   └── presentation/      # Screen-lər, widget-lər
    ├── location/              # Eyni struktur — Geolocator inteqrasiyası
    ├── splash/
    └── home/
```

## İstifadə olunan paketlər

| Paket | Versiya | Məqsəd |
|---|---|---|
| flutter_bloc | ^8.1.6 | State management (Cubit) |
| equatable | ^2.0.5 | State/entity müqayisəsi |
| go_router | ^14.2.0 | Naviqasiya və route protection |
| get_it | ^7.7.0 | Dependency injection |
| shared_preferences | ^2.2.3 | Sessiya/token saxlanması |
| dio | ^5.4.3+1 | HTTP client (gələcək real API üçün hazır) |
| geolocator | ^12.0.0 | Cihazın GPS mövqeyi |
| geocoding | ^5.0.0 | Koordinatları ünvana çevirmə (reverse geocoding) |
| flutter_screenutil | ^5.9.3 | Responsive UI ölçüləri |

## Quraşdırma

```bash
git clone https://github.com/fourhadd/Dev-Project-4.git
cd Dev-Project-4
flutter pub get
flutter run
```

**Tələblər:** Flutter SDK `>=3.0.0 <4.0.0`, Android/iOS emulator və ya fiziki cihaz.


## Auth axını necə işləyir

1. Tətbiq açılanda `AuthCubit` `AuthChecking` state-ində olur və `SessionRepository`-dən saxlanmış sessiyanı oxumağa çalışır
2. Sessiya tapılarsa → `AuthAuthenticated`, tapılmazsa → `AuthUnauthenticated`
3. `go_router`-in `redirect` funksiyası bu state-ə əsasən istifadəçini `/login` və ya `/home`-a yönləndirir
4. Login/Register uğurlu olduqda token və user `shared_preferences`-ə yazılır, `AuthCubit.setAuthenticated()` çağırılır
5. Logout zamanı sessiya təmizlənir və `AuthUnauthenticated` state-i emit olunur

