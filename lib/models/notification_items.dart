import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime? receivedAt;
  final bool read;
  NotificationItem(
      {required this.id,
      required this.title,
      required this.body,
      required this.data,
      required this.receivedAt,
      required this.read});

  factory NotificationItem.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return NotificationItem(
        id: doc.id,
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        data: Map<String, dynamic>.from(map['data'] ?? {}),
        receivedAt: map['receivedAt'] != null
            ? (map['receivedAt'] as Timestamp).toDate()
            : null,
        read: map['read'] ?? false);
  }
}
