import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripmate/models/bus_agency.dart';

class FirestoreService {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static CollectionReference get users => _instance.collection('users');
  static CollectionReference get agencies => _instance.collection('agencies'); 
  static CollectionReference get bookings => _instance.collection('bookings');
  static CollectionReference get seats => _instance.collection('seats');

  // User operations
  static Future<void> saveUser(User user) async {
    await users.doc(user.uid).set({
      'email': user.email,
      'name': user.displayName,
      'phone': user.phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Bus agency operations  
  static Stream<List<BusAgency>> getAgencies() {
    return agencies.snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => BusAgency.fromMap(doc.data() as Map<String, dynamic>)).toList()
    );
  }

  // Booking operations
  static Future<void> createBooking({
    required String agencyId,
    required List<int> seats,
    required double amount,
    required String paymentMethod,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await bookings.add({
      'userId': user.uid,
      'agencyId': agencyId,
      'seats': seats,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': 'confirmed',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update seat availability
    final batch = _instance.batch();
    for (final seat in seats) {
      final seatRef = agencies.doc(agencyId).collection('seats').doc(seat.toString());
      batch.update(seatRef, {'available': false});
    }
    await batch.commit();
  }

  // Seat availability
  static Stream<DocumentSnapshot> getSeatAvailability(String agencyId, int seatNumber) {
    return agencies.doc(agencyId)
      .collection('seats')
      .doc(seatNumber.toString())
      .snapshots();
  }
}