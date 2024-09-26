import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FormError {
  emptyCard,
  invalidCard,
  emptyExpiry,
  emptyCvv,
  emptyCardholder,
  emptyEmail,
  invalidEmail,
  emptyPhone,
  invalidPhone,
}

String? localisedErrorMessage(FormError? type, AppLocalizations appLocalizations) {
  switch (type) {
    case null:
      return null;
    case FormError.emptyCard:
      return appLocalizations.cardNumberRequired;
    case FormError.invalidCard:
      return appLocalizations.cardDoesNotExist;
    case FormError.emptyExpiry:
      return appLocalizations.cardExpiryRequired;
    case FormError.emptyCvv:
      return appLocalizations.cvvRequired;
    case FormError.emptyCardholder:
      return appLocalizations.cardHolderNameRequired;
    case FormError.emptyEmail:
      return appLocalizations.emailRequired;
    case FormError.invalidEmail:
      return appLocalizations.invalidEmailFormat;
    case FormError.emptyPhone:
      return appLocalizations.phoneNumberRequired;
    case FormError.invalidPhone:
      return appLocalizations.incompletePhoneNumber;
  }
}
