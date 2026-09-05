import 'package:flutter/material.dart';

enum WalletType { bank, cash, credit, upi, savings }

class WalletModel {
  final String id;
  final String name;
  final WalletType type;
  final double balance;
  final String? accountNumber;
  final Color color;
  final IconData icon;

  const WalletModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.accountNumber,
    required this.color,
    required this.icon,
  });

  WalletModel copyWith({
    String? id,
    String? name,
    WalletType? type,
    double? balance,
    String? accountNumber,
    Color? color,
    IconData? icon,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      accountNumber: accountNumber ?? this.accountNumber,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}
