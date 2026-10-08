import 'package:flutter/material.dart';
import 'package:never_overflows/contact_card.dart';
import 'package:never_overflows/contacts.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('20 contacts'),
      Expanded(
        child: ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: contacts.length,
          itemBuilder: (ctx, i) => ContactCard(contact: contacts[i]),
          separatorBuilder: (ctx, _) => const Divider(),
        ),
      ),
    ],
  );
}
