import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetDetailsPage extends StatelessWidget {
  final String petId;

  const PetDetailsPage({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Details')),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('pets').doc(petId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Pet not found'));
          }

          final pet = snapshot.data!.data()!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                pet['image_url'] != null && pet['image_url'].isNotEmpty
                    ? Image.network(pet['image_url'], height: 200, fit: BoxFit.cover)
                    : const Icon(Icons.pets, size: 100),
                const SizedBox(height: 16),
                Text(pet['name'] ?? 'No Name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("${pet['type'] ?? 'Unknown'}, Age: ${pet['age'] ?? '?'}", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Text(pet['description'] ?? 'No description', style: const TextStyle(fontSize: 16)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/meetup_scheduling',
                      arguments: {
                        'petId': petId,
                        'ownerId': 'owner_placeholder', // replace with actual ownerId if you have it
                      },
                    );
                  },
                  child: const Text('Schedule Meetup'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
