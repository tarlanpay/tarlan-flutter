class CardEncryptData {
  String? _cvc;
  String? _month;
  String? _pan;
  String? _year;
  String? _fullName;

  CardEncryptData({
    String? cvc,
    String? month,
    String? pan,
    String? year,
    String? fullName,
  })  : _cvc = cvc,
        _month = month,
        _pan = pan,
        _year = year,
        _fullName = fullName;

  String? get fullName => _fullName;

  set fullName(String? value) {
    _fullName = value;
  }

  String? get cvc => _cvc;

  set cvc(String? value) {
    _cvc = value;
  }

  String? get month => _month;

  set month(String? value) {
    _month = value;
  }

  String? get pan => _pan;

  set pan(String? value) {
    _pan = value;
  }

  String? get year => _year;

  set year(String? value) {
    _year = value;
  }
}
