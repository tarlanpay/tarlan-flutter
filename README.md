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

### Использование своего UI для формы оплаты

Если вы хотите использовать свой UI для формы оплаты, то можете использовать `TarlanProvider` для проведения платежа. Вот руководство по использованию `TarlanProvider`:

#### `TarlanProvider` поддерживает следующие методы:

- `setFlow(TarlanFlow flow)`: Устанавливает текущий процесс оплаты.
- `load()`: Загружает данные мерчанта и транзакции.
- `createTransaction()`: Создает новую транзакцию.
- `encryptCardData(String publicKey)`: Шифрует данные карты с использованием публичного ключа.
- `clearError()`: Очищает текущую ошибку.
- `clearSuccess()`: Очищает текущий успешный результат.
- `setCardNumber(String value)`: Устанавливает номер карты.
- `setExpiryMonth(String value)`: Устанавливает месяц окончания срока действия карты.
- `setExpiryYear(String value)`: Устанавливает год окончания срока действия карты.
- `setCVV(String value)`: Устанавливает CVV карты.
- `setCardHolderName(String value)`: Устанавливает имя владельца карты.
- `setSaveCard(bool? saveCard)`: Устанавливает флаг сохранения карты.
- `setUserPhone(String? phone)`: Устанавливает номер телефона пользователя.
- `setUserEmail(String? email)`: Устанавливает email пользователя.
- `receiptPdfUrl()`: Возвращает URL для скачивания чека.
- `deactivateCard(String cardToken)`: Деактивирует карту по токену.
- `hasPhoneEmail()`: Проверяет наличие номера телефона или email у мерчанта.

#### Пример использования `TarlanProvider`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarlan_payments/tarlan_payments.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TarlanProvider(),
      child: MaterialApp(
        home: PaymentFormScreen(),
      ),
    );
  }
}

class PaymentFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Payment Form')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Card Number'),
                    onChanged: provider.setCardNumber,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Expiry Month'),
                    onChanged: provider.setExpiryMonth,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Expiry Year'),
                    onChanged: provider.setExpiryYear,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'CVV'),
                    onChanged: provider.setCVV,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Card Holder Name'),
                    onChanged: provider.setCardHolderName,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      provider.createTransaction();
                    },
                    child: Text('Pay'),
                  ),
                ],
              ),
            ),
    );
  }
}
```

Это руководство помогает быстро настроить и использовать `Tarlan Payments` в вашем Flutter-приложении, а также предоставляет возможность создать собственный UI для проведения платежей с использованием `TarlanProvider`.
