import 'package:flutter_test/flutter_test.dart';
import 'package:the_50_yard_challenge/features/home/data/home_data.dart';

void main() {
  group('HomeProfile', () {
    HomeProfile profile({int lawns = 0, String name = 'Marcus Reed'}) =>
        HomeProfile(
          displayName: name,
          state: 'Alabama',
          joinedAt: DateTime(2025, 8, 10),
          totalLawns: lawns,
          totalHours: 0,
        );

    test('greets by the first word of the name', () {
      expect(profile().firstName, 'Marcus');
      expect(profile(name: 'Marcus').firstName, 'Marcus');
      expect(profile(name: '  Ada  Lovelace ').firstName, 'Ada');
      expect(profile(name: '').firstName, 'there');
    });

    test('progress is a fraction of fifty, and never overflows', () {
      expect(profile(lawns: 0).progress, 0);
      expect(profile(lawns: 25).progress, 0.5);
      expect(profile(lawns: 50).progress, 1);
      // Someone who keeps going past the challenge still shows a full ring.
      expect(profile(lawns: 73).progress, 1);
    });

    test('the next lawn is the one after the last', () {
      expect(profile(lawns: 0).nextLawnNumber, 1);
      expect(profile(lawns: 3).nextLawnNumber, 4);
    });
  });

  group('MowedCategory', () {
    test('matches the wording v1 wrote into who_for', () {
      expect(MowedCategory.match('Elderly'), MowedCategory.elderly);
      expect(MowedCategory.match('elderly'), MowedCategory.elderly);
      expect(MowedCategory.match('  Single Parent '), MowedCategory.singleParent);
      expect(MowedCategory.match('Veteran'), MowedCategory.veteran);
      // v1 called this Deployed Military; the design calls it Active Duty.
      expect(MowedCategory.match('Deployed Military'), MowedCategory.activeDuty);
      expect(MowedCategory.match('Active Duty'), MowedCategory.activeDuty);
      expect(MowedCategory.match('Disabled'), MowedCategory.disabled);
      expect(MowedCategory.match('First Responder'), MowedCategory.firstResponder);
    });

    test('leaves anything unrecognised alone', () {
      expect(MowedCategory.match(null), isNull);
      expect(MowedCategory.match(''), isNull);
      expect(MowedCategory.match('A neighbour'), isNull);
    });

    test('every category has an illustration', () {
      for (final category in kMowedCategories) {
        expect(category.iconPath, startsWith('assets/images/home/'));
        expect(category.iconPath, endsWith('.png'));
      }
    });
  });

  group('MowingWeek', () {
    test('counts only the days actually mowed', () {
      const week = MowingWeek(days: [
        DayState.mowed, DayState.missed, DayState.mowed, DayState.mowed,
        DayState.mowed, DayState.today, DayState.upcoming,
      ]);
      expect(week.mowedCount, 4);
    });
  });
}
