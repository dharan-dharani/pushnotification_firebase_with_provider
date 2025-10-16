import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notification_provider.dart';
import '../models/notification_items.dart';
import 'edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        final notifications = provider.notifications;
        return Scaffold(
          appBar: AppBar(
            title: Text('Notifications (${provider.unreadCount()})'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // force refresh by restarting listener (not always necessary)
                  provider.listenToNotification();
                },
              )
            ],
          ),
          body: notifications.isEmpty
              ? const Center(child: Text('No notifications yet'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final NotificationItem item = notifications[index];
                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => provider.deleteNotification(item.id),
                      child: ListTile(
                        tileColor: item.read ? null : Colors.indigo.shade50,
                        leading: Icon(item.read
                            ? Icons.mark_email_read
                            : Icons.mark_email_unread),
                        title: Text(item.title,
                            style: TextStyle(
                                fontWeight: item.read
                                    ? FontWeight.normal
                                    : FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.body),
                            if (item.receivedAt != null)
                              Text('${item.receivedAt}',
                                  style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => EditScreen(item: item)));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                provider.deleteNotification(item.id);
                              },
                            ),
                          ],
                        ),
                        onTap: () =>
                            provider.updateNotification(item.id, read: true),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await provider.addNotification('Manual Title', 'Manual body',
                  data: {'source': 'manual'});
            },
          ),
        );
      },
    );
  }
}
