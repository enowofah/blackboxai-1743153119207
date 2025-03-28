import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/models/bus_agency.dart';

class PaymentScreen extends StatefulWidget {
  final BusAgency agency;
  final List<int> selectedSeats;
  final int totalAmount;

  const PaymentScreen({
    super.key,
    required this.agency,
    required this.selectedSeats,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  final TextEditingController _phoneController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_selectedPaymentMethod == null || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select payment method and enter phone number')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isProcessing = false);
      _showPaymentSuccess();
    });
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agency: ${widget.agency.name}'),
            Text('Amount: ${widget.totalAmount} FCFA'),
            Text('Seats: ${widget.selectedSeats.join(', ')}'),
            const SizedBox(height: 20),
            const Text('Your booking has been confirmed!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
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
              // Booking Summary
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
                      'Booking Summary',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Agency: ${widget.agency.name}',
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                    Text(
                      'Seats: ${widget.selectedSeats.join(', ')}',
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                    Text(
                      'Total: ${widget.totalAmount} FCFA',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Payment Method Selection
              Text(
                'Select Payment Method',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...['MTN Mobile Money', 'Orange Money', 'Express Union'].map(
                (method) => RadioListTile<String>(
                  title: Text(
                    method,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() => _selectedPaymentMethod = value);
                  },
                  activeColor: const Color(0xFF4A6FA5),
                ),
              ),
              const SizedBox(height: 20),
              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.phone, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
              ),
              const SizedBox(height: 30),
              // Pay Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6FA5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Pay ${widget.totalAmount} FCFA',
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