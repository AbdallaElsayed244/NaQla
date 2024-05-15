
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/screens/order_info/orderinfo.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  group('OrderInfoScreen', () {
    late MockFirebaseFirestore mockFirestore;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockDocumentSnapshot mockDocumentSnapshot;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockQuerySnapshot = MockQuerySnapshot();
      mockDocumentSnapshot = MockDocumentSnapshot();
    });

    testWidgets('renders CircularProgressIndicator when loading', (tester) async {
      await tester.pumpWidget(MaterialApp(home: OrderInfoScreen(email: 'test@example.com')));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders "No Drivers Right Now" when no orders', (tester) async {
      when(mockFirestore.collection('Orders').doc('test@example.com').get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false);
      when(mockQuerySnapshot.docs).thenReturn([]);

      await tester.pumpWidget(MaterialApp(home: OrderInfoScreen(email: 'test@example.com')));
      await tester.pump();

      expect(find.text('No Drivers Right Now'), findsOneWidget);
    });

    testWidgets('renders orders correctly', (tester) async {
      final mockDocs = [
        MockDocumentSnapshot(),
        MockDocumentSnapshot(),
      ];
      when(mockFirestore.collection('Orders').doc('test@example.com').get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({'someData': 'value'});
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);

      await tester.pumpWidget(MaterialApp(home: OrderInfoScreen(email: 'test@example.com')));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Dismissible), findsNWidgets(mockDocs.length));
    });
  });
