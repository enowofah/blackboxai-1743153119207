import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/models/bus_agency.dart';
import 'package:tripmate/screens/payment_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final BusAgency agency;
  final int passengers;

  const SeatSelectionScreen({
    super.key,
    required this.agency,
    required this.passengers,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<int> _selectedSeats = [];
  final int _totalSeats = 30;
  final List<int> _bookedSeats = [];
  final List<StreamSubscription> _seatSubscriptions = [];

  @override
  void initState() {
    super.initState();
    _loadSeatAvailability();
  }

  @override
  void dispose() {
    for (final sub in _seatSubscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  void _loadSeatAvailability() {
    for (int i = 1; i <= _totalSeats; i++) {
      final sub = FirestoreService.getSeatAvailability(
        widget.agency.id, 
        i
      ).listen((snapshot) {
        if (snapshot.exists && !(snapshot.data() as Map<String, dynamic>)['available']) {
          if (!_bookedSeats.contains(i)) {
            setState(() => _bookedSeats.add(i));
          }
        } else {
          setState(() => _bookedSeats.remove(i));
        }
      });
      _seatSubscriptions.add(sub);
    }
  }

  void _toggleSeatSelection(int seatNumber) {
    setState(() {
      if (_selectedSeats.contains(seatNumber)) {
        _selectedSeats.remove(seatNumber);
      } else if (_selectedSeats.length < widget.passengers &&
          !_bookedSeats.contains(seatNumber)) {
        _selectedSeats.add(seatNumber);
      }
    });
  }

  Color _getSeatColor(int seatNumber) {
    if (_bookedSeats.contains(seatNumber)) {
      return Colors.grey;
    } else if (_selectedSeats.contains(seatNumber)) {
      return const Color(0xFF4A6FA5);
    }
    return Colors.white.withOpacity(0.2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Seats',
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
            children: [
              // Bus Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.agency.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.agency.departureTime.format(context)} - ${widget.agency.arrivalTime.format(context)}',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '${widget.agency.price} FCFA',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Seat Selection Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _totalSeats,
                  itemBuilder: (context, index) {
                    final seatNumber = index + 1;
                    return GestureDetector(
                      onTap: () => _toggleSeatSelection(seatNumber),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getSeatColor(seatNumber),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            seatNumber.toString(),
                            style: GoogleFonts.poppins(
                              color: _bookedSeats.contains(seatNumber)
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Selected Seats Summary
              if (_selectedSeats.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Selected Seats: ${_selectedSeats.join(', ')}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total: ${widget.agency.price * _selectedSeats.length} FCFA',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedSeats.length == widget.passengers
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                agency: widget.agency,
                                selectedSeats: _selectedSeats,
                                totalAmount:
                                    widget.agency.price * _selectedSeats.length,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6FA5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Continue to Payment',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}