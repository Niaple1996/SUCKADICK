import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:senioren_app/data/models/checkin_settings.dart';
import 'package:senioren_app/data/repositories/checkin_repository.dart';
import 'package:senioren_app/services/checkin_service.dart';

class _MockCheckinRepository extends Mock implements CheckinRepository {}

void main() {
  late CheckinService service;
  late _MockCheckinRepository repository;

  setUp(() {
    repository = _MockCheckinRepository();
    service = CheckinService(repository: repository);
  });

  test('calculateNextDue respects frequency', () {
    final now = DateTime(2023, 1, 1);
    expect(service.calculateNextDue(now, 'daily'), DateTime(2023, 1, 2));
    expect(service.calculateNextDue(now, '2d'), DateTime(2023, 1, 3));
    expect(service.calculateNextDue(now, 'weekly'), DateTime(2023, 1, 8));
  });

  test('timerLabel returns formatted remaining time', () {
    final settings = CheckinSettings(
      frequency: 'daily',
      enabled: true,
      nextDueAt: DateTime.now().add(const Duration(hours: 5, minutes: 30)),
    );
    final label = service.timerLabel(settings);
    expect(label.contains('Stunden verbleibend'), isTrue);
  });

  test('updateSettings saves data with computed due date', () async {
    when(() => repository.saveSettings(any(), any())).thenAnswer((_) async {});
    final settings = CheckinSettings(frequency: 'daily', enabled: true, nextDueAt: null);
    await service.updateSettings(uid: 'uid', settings: settings);
    verify(() => repository.saveSettings('uid', any(that: isA<CheckinSettings>()))).called(1);
  });
}
