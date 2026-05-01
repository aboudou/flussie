import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flussie/models/drive.dart';
import 'package:flussie/providers/api/api_provider.dart';
import 'package:flussie/viewmodels/drive_list_vm.dart';

class MockApiProvider extends Mock implements ApiProvider {}

void main() {
  late MockApiProvider mockApi;
  late DriveListViewModel vm;

  setUp(() {
    mockApi = MockApiProvider();
    when(() => mockApi.getDrives(any(), any(), any()))
        .thenAnswer((_) async => const DriveList(results: []));
    vm = DriveListViewModel(vin: 'TEST_VIN', apiProvider: mockApi);
  });

  tearDown(() => vm.dispose());

  group('refresh', () {
    test('populates driveList on success', () async {
      final drives = [const Drive(id: 1), const Drive(id: 2)];
      when(() => mockApi.getDrives(any(), any(), any()))
          .thenAnswer((_) async => DriveList(results: drives));

      await vm.refresh();

      expect(vm.driveList.value.results.length, equals(2));
      expect(vm.errorMessage.value, isEmpty);
    });

    test('sets errorMessage on failure', () async {
      when(() => mockApi.getDrives(any(), any(), any()))
          .thenThrow(Exception('API error'));

      await vm.refresh();

      expect(vm.driveList.value.results, isEmpty);
      expect(vm.errorMessage.value, isNotEmpty);
    });

    test('clears errorMessage on success after a previous failure', () async {
      vm.errorMessage.value = 'previous error';
      when(() => mockApi.getDrives(any(), any(), any()))
          .thenAnswer((_) async => const DriveList(results: []));

      await vm.refresh();

      expect(vm.errorMessage.value, isEmpty);
    });
  });

  group('getDriveDistance', () {
    test('formats distance with km suffix', () {
      final drive = Drive(odometerDistance: 123.45);
      expect(vm.getDriveDistance(drive), contains('km'));
    });

    test('returns non-empty string when distance is null', () {
      expect(vm.getDriveDistance(const Drive()), isNotEmpty);
    });
  });

  group('getDriveDuration', () {
    test('formats hours and minutes', () {
      final drive = Drive(
        startedAt: 1_000_000,
        endedAt: 1_000_000 + 2 * 3600 + 30 * 60,
      );
      expect(vm.getDriveDuration(drive), equals('2h 30m'));
    });

    test('formats minutes only when under 1 hour', () {
      final drive = Drive(
        startedAt: 1_000_000,
        endedAt: 1_000_000 + 45 * 60,
      );
      expect(vm.getDriveDuration(drive), equals('0h 45m'));
    });

    test('returns non-empty string for null timestamps', () {
      expect(vm.getDriveDuration(const Drive()), isNotEmpty);
    });
  });

  group('getDriveStartLocation', () {
    test('prefers startingSavedLocation over startingLocation', () {
      final drive = Drive(
        startingLocation: 'GPS address',
        startingSavedLocation: 'Home',
      );
      expect(vm.getDriveStartLocation(drive), equals('Home'));
    });

    test('falls back to startingLocation when savedLocation is empty', () {
      final drive = Drive(
        startingLocation: 'GPS address',
        startingSavedLocation: '',
      );
      expect(vm.getDriveStartLocation(drive), equals('GPS address'));
    });
  });
}
