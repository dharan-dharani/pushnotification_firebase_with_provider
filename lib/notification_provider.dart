import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pushnotification_firebase_with_provider/models/notification_items.dart';

class NotificationProvider extends ChangeNotifier {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('notification');
  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  void listenToNotification() {
    _collection
        .orderBy('receivedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _notifications =
          snapshot.docs.map((e) => NotificationItem.fromDoc(e)).toList();
      notifyListeners();
    });
  }

  Future<void> addNotification(String title, String body,
      {Map<String, dynamic>? data}) async {
    await _collection.add({
      'title': title,
      'body': body,
      'data': data ?? {},
      'receivedAt': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  Future<void> updateNotification(String id,
      {String? title, String? body, bool? read}) async {
    final updateMap = <String, dynamic>{};
    if (title != null) updateMap['title'] = title;
    if (body != null) updateMap['body'] = body;
    if (read != null) updateMap['read'] = read;

    if (updateMap.isEmpty) return;
    await _collection.doc(id).update(updateMap);
  }

  Future<void> deleteNotification(String id) async {
    await _collection.doc(id).delete();
  }

  int unreadCount()=> _notifications.where((element) => !element.read).length;
}
