import 'package:flutter/material.dart';
import 'transaction_details_screen.dart';

class InProgressTransactionsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> inProgressTransactions;

  const InProgressTransactionsScreen({
    super.key,
    required this.inProgressTransactions,
  });

  @override
  State<InProgressTransactionsScreen> createState() =>
      _FancyTransactionsScreenState();
}

class _FancyTransactionsScreenState
    extends State<InProgressTransactionsScreen> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102542),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'معاملات قيد الإنجاز',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: widget.inProgressTransactions.length,
        itemBuilder: (context, index) {
          final tx = widget.inProgressTransactions[index];
          final isHovered = hoveredIndex == index;

          return MouseRegion(
            onEnter: (_) => setState(() => hoveredIndex = index),
            onExit: (_) => setState(() => hoveredIndex = null),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransactionDetailsScreen(transaction: tx),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isHovered ? const Color(0xFFF3F8FF) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isHovered
                              ? const Color(0xFFDCEBFA)
                              : const Color(0x22102542),
                      blurRadius: isHovered ? 14 : 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F4471), Color(0xFF1F7CBF)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            tx['id'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.person,
                          size: 18,
                          color: Color(0xFF102542),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tx['citizenName'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF102542),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_car,
                          size: 18,
                          color: Colors.indigo,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tx['type'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tx['receivedDate'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
