import 'package:crud_api/functions/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements http.Client {}

void main() {
  group('ApiServices tests', () {
    late ApiServices apiServices;
    late MockHTTPClient mockHTTPClient;

    setUp(() {
      mockHTTPClient = MockHTTPClient();
      apiServices = ApiServices(mockHTTPClient);
    });

    test('fetchApi returns a list of employees', () async {
      // Arrange
      final specificUrl = Uri.parse(
          'https://crudcrud.com/api/9dd7ee0d61664b18bb557bb6feadd5df/employees');

      when(() => mockHTTPClient.get(specificUrl))
          .thenAnswer((_) async => http.Response(''' 
        [
          {
            "_id": "65a60454ada52203e86c0ff0",
            "address": "nharoth parmbil house karinganad vilayur po ",
            "city": "Palakkad",
            "country": "India",
            "email": "mdmufeednp@gmail.com",
            "job": "flutter dev",
            "sex": "male",
            "number": "9745281566",
            "state": "Kerala",
            "name": "Majroos Muthu"
          }
        ]
      ''', 200));

      // Act
      final result = await apiServices.fetchApi();

      // Assert
      expect(result, isA<List>());
      expect(result!.length, 5);
      expect(result[0]['name'], 'Majroos Muthu');

      // Verify
      verifyNever(() => mockHTTPClient.get(specificUrl)).called(0);
    });
    test('addApi adds a new employee', () async {
      // Arrange
      final specificUrl = Uri.parse('https://crudcrud.com/api/employees');
      final requestBody = {
        'name': 'New Employee',
        'email': 'newemployee@gmail.com',
        'job': 'New Job',
      };

      when(() => mockHTTPClient.post(
            specificUrl,
            body: jsonEncode(requestBody),
            headers: {'Content-Type': 'application/json'},
          )).thenAnswer(
        (_) async => http.Response('{"status": "success"}', 201),
      );

      // Act
      final result = await apiServices.addApi(requestBody);

      // Assert
      expect(result, true);

      // Verify
      verifyNever(() => mockHTTPClient.post(
            specificUrl,
            body: jsonEncode(requestBody),
            headers: {'Content-Type': 'application/json'},
          )).called(0);
    });
    test('updateApi updates an existing employee', () async {
      // Arrange
      final specificUrl =
          Uri.parse('https://crudcrud.com/api/employees/employeeIdToUpdate');
      final requestBody = {
        'name': 'Updated Employee',
        'email': 'updatedemployee@gmail.com',
        'job': 'Updated Job',
      };

      when(() => mockHTTPClient.put(
            specificUrl,
            body: jsonEncode(requestBody),
            headers: {'Content-Type': 'application/json'},
          )).thenAnswer(
        (_) async => http.Response('{"status": "success"}', 200),
      );

      // Act
      final result =
          await apiServices.updateApi('employeeIdToUpdate', requestBody);

      // Assert
      expect(result, true);

      // Verify
      verifyNever(() => mockHTTPClient.put(
            specificUrl,
            body: jsonEncode(requestBody),
            headers: {'Content-Type': 'application/json'},
          )).called(0);
    });
    test('deleteById deletes an existing employee', () async {
      // Arrange
      final employeeIdToDelete = 'employeeIdToDelete';
      final specificUrl =
          Uri.parse('https://crudcrud.com/api/employees/$employeeIdToDelete');

      when(() => mockHTTPClient.delete(
            specificUrl,
          )).thenAnswer(
        (_) async => http.Response('{"status": "success"}', 200),
      );

      // Act
      final result = await apiServices.deleteById(employeeIdToDelete);

      // Assert
      expect(result, true);

      // Verify
      verifyNever(() => mockHTTPClient.delete(
            specificUrl,
          )).called(0);
    });

    // Add more tests for other methods (deleteById, updateApi, ) similarly.
  });
}
