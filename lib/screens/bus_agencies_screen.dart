import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/models/bus_agency.dart';
import 'package:tripmate/screens/seat_selection_screen.dart';

class BusAgenciesScreen extends StatelessWidget {
  final String from;
  final String to;
  final DateTime date;
  final TimeOfDay time;
  final int passengers;

  const BusAgenciesScreen({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data - in a real app this would come from Firestore
    final List<BusAgency> agencies = [
      BusAgency(
        id: '1',
        name: 'Cameroon Travel Express',
        logo: 'assets/images/cte_logo.png',
        price: 5000,
        departureTime: TimeOfDay(hour: 7, minute: 30),
        arrivalTime: TimeOfDay(hour: 12, minute: 0),
        amenities: ['AC', 'WiFi', 'TV', 'Toilet'],
      ),
      BusAgency(
        id: '2',
        name: 'Guarantee Express',
        logo: 'assets/images/guarantee_logo.png',
        price: 4500,
        departureTime: TimeOfDay(hour: 9, minute: 0),
        arrivalTime: TimeOfDay(hour: 13, minute: 30),
        amenities: ['AC', 'Toilet'],
      ),
      BusAgency(
        id: '3',
        name: 'Amour Mezam',
        logo: 'assets/images/amour_logo.png',
        price: 4000,
        departureTime: TimeOfDay(hour: 10, minute: 30),
        arrivalTime: TimeOfDay(hour: 15, minute: 0),
        amenities: ['AC'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Buses',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A6FA5), Color(0xFF2C3E50)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '$from to $to • ${DateFormat('MMM dd, yyyy').format(date)} • ${time.format(context)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: agencies.length,
                  itemBuilder: (context, index) {
                    final agency = agencies[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  agency.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${agency.price} FCFA',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.departure_board,
                                    color: Colors.white70, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  '${agency.departureTime.format(context)} - ${agency.arrivalTime.format(context)}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: agency.amenities
                                  .map((amenity) => Chip(
                                        label: Text(
                                          amenity,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                          ),
                                        ),
                                        backgroundColor:
                                            Colors.white.withOpacity(0.2),
                                        labelStyle:
                                            const TextStyle(color: Colors.white),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/seatSelection',
                                    arguments: {
                                      'agency': agency,
                                      'passengers': passengers,
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A6FA5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Book Now',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}