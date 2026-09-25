const _monthAbbreviations = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const _weekdayNames = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];

/// "1st", "2nd", "3rd", "4th"… 11–13 are always "th".
String ordinalDay(int day) {
  if (day >= 11 && day <= 13) return '${day}th';
  return switch (day % 10) {
    1 => '${day}st',
    2 => '${day}nd',
    3 => '${day}rd',
    _ => '${day}th',
  };
}

/// "10th Aug", the way the app writes a date in prose.
String dayAndMonth(DateTime date) =>
    '${ordinalDay(date.day)} ${_monthAbbreviations[date.month - 1]}';

/// "10th/Aug", used where space is tight.
String dayOverMonth(DateTime date) =>
    '${ordinalDay(date.day)}/${_monthAbbreviations[date.month - 1]}';

/// "12th/ Aug/ 2026", the form's date field.
String dayMonthYear(DateTime date) =>
    '${ordinalDay(date.day)}/ ${_monthAbbreviations[date.month - 1]}/ '
    '${date.year}';

/// "Monday".
String weekdayName(DateTime date) => _weekdayNames[date.weekday - 1];
