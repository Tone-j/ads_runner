import 'package:equatable/equatable.dart';

class PaymentRecord extends Equatable {
  final String id;
  final DateTime date;
  final double amount;
  final String description;
  final String status;
  final String? invoiceUrl;

  const PaymentRecord({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.status,
    this.invoiceUrl,
  });

  @override
  List<Object?> get props => [id, date, amount, status];
}
