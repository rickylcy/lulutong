import 'package:flutter/material.dart';

class JobListPage extends StatelessWidget {
  final List<Map<String, dynamic>> jobs;

  const JobListPage({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title Bar
          Container(
            margin: const EdgeInsets.all(8.0),
            child: const Text(
              "Job List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Scrollable Job List
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: index == 0
                      ? Colors.blue[50] // Highlight current job
                      : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: job['status'] == 'Completed'
                          ? Colors.green
                          : Colors.orange,
                      child: Icon(
                        job['status'] == 'Completed'
                            ? Icons.check
                            : Icons.access_time,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(index == 0
                        ? "Current Job: Stop ${job['id']}"
                        : "Stop ${job['id']}"),
                    subtitle: Text(job['address']),
                    trailing: Text(
                      job['status'],
                      style: TextStyle(
                        color: job['status'] == 'Completed'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    onTap: () {
                      print("Tapped Job ${job['id']}");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
