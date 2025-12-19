import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pet_details_page.dart';
import 'add_pet_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final petsCollection = FirebaseFirestore.instance.collection('pets');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home (Pet Listings)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: petsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading pets'));
          }

          final pets = snapshot.data?.docs ?? [];
          if (pets.isEmpty) {
            return const Center(child: Text('No pets available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index].data() as Map<String, dynamic>;
              final petId = pets[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: pet['image_url'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(pet['image_url']),
                        )
                      : const CircleAvatar(child: Icon(Icons.pets)),
                  title: Text(pet['name'] ?? 'Unknown'),
                  subtitle: Text(
                    '${pet['type'] ?? 'Type unknown'} - ${pet['age'] ?? '?'} years',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PetDetailsPage(petId: petId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPetPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
