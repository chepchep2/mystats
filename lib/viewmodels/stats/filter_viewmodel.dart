import 'package:flutter/foundation.dart';

class FilterViewModel extends ChangeNotifier {
  int _selectedYear;
  int _selectedMonth;

  FilterViewModel() 
    : _selectedYear = DateTime.now().year,
      _selectedMonth = DateTime.now().month;

  int get selectedYear => _selectedYear;
  int get selectedMonth => _selectedMonth;

  void setYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void resetToCurrentDate() {
    _selectedYear = DateTime.now().year;
    _selectedMonth = DateTime.now().month;
    notifyListeners();
  }
}
