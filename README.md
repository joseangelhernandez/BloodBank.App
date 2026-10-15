# blood_bank

App Flutter del proyecto final de Desarrollo Móvil (banco de sangre).
Los datos y el login viven en el backend .NET (`../BloodBank.Backend`), que usa Firebase Authentication.
La app no habla con Firebase directamente.

## Cómo ejecutarla

**1. Primero el backend** (en otra terminal):

```bash
cd ../BloodBank.Backend
docker compose up -d                                  # SQL Server
dotnet run --project src/Web --launch-profile http    # API en http://localhost:5219
```

**2. Luego la app:**

```bash
flutter pub get
flutter run
```

**3. Dirección del backend:** revisa `lib/general/config/config.dart` → `AppConfig.apiBaseUrl`.

| Dispositivo | Valor |
|---|---|
| Emulador de Android | `http://10.0.2.2:5219` (el que viene puesto) |
| Simulador de iOS | `http://localhost:5219` |
| Celular físico | `http://<IP de tu computadora>:5219` |

## Estructura

```
lib/
├── models/      datos (fromJson / toJson)
├── services/    llamadas HTTP al backend
├── providers/   estado con Provider (ChangeNotifier)
└── screens/     pantallas
```

## Más documentación

- Cómo está conectada la app (Provider, login, token, limitaciones):
  [`BloodBank.Backend/docs/FLUTTER_INTEGRATION.md`](../BloodBank.Backend/docs/FLUTTER_INTEGRATION.md)
- Backend (endpoints, base de datos, Firebase):
  [`BloodBank.Backend/README.md`](../BloodBank.Backend/README.md)
