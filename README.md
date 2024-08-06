# Tarlan Payments - Flutter

Tarlan Payments - это библиотека для интеграции платежной системы Tarlan в ваше Flutter-приложение.

## Описание

Tarlan Payments предоставляет удобный способ интеграции платежной системы Tarlan в ваше приложение. С помощью `TarlanBuilder` вы можете легко настроить инициализацию платежного процесса, задав необходимые параметры, такие как язык, окружение, идентификатор мерчанта и проекта.

## Установка

Добавьте Tarlan Payments в ваш `pubspec.yaml` файл:

```yaml
dependencies:
  flutter:
    sdk: flutter
  tarlan_payments:
    git:
      url: https://github.com/yourusername/tarlan_payments.git
      ref: main
```

## Использование

### Параметры
#### `TarlanBuilder` поддерживает следующие методы:

- `onSuccess(VoidCallback callback)`: Устанавливает callback, который будет вызван при успешном завершении платежа.
- `onError(VoidCallback callback)`: Устанавливает callback, который будет вызван при ошибке платежа.
- `language(String language)`: Устанавливает язык интерфейса.
- `environment(Environment environment)`: Устанавливает окружение (например, prod или sandbox).
- `merchantId(String merchantId)`: Устанавливает идентификатор мерчанта.
- `projectId(String projectId)`: Устанавливает идентификатор проекта.

### Инициализация
Для инициализации Tarlan Payments используйте `TarlanBuilder`. Пример использования:

```dart
import 'package:flutter/material.dart';
import 'package:tarlan_payments/tarlan_payments.dart';
import 'package:tarlan_payments/network/environment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarlan Payments Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            TarlanBuilder(context: context, url: 'https://example.com/payment')
              .onSuccess(() {
                print('Payment successful');
              })
              .onError(() {
                print('Payment failed');
              })
              .language('en')
              .environment(Environment.production)
              .merchantId('your_merchant_id')
              .projectId('your_project_id')
              .initialize();
          },
          child: Text('Start Payment'),
        ),
      ),
    );
  }
}
```
