import 'package:flutter/material.dart';

void main() {
  runApp(const EmergencyApp());
}

class EmergencyApp extends StatelessWidget {
  const EmergencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Response',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomePage(),
    );
  }
}

class Incident {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String location;
  final String time;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.location,
    required this.time,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Incident> incidents = [
    Incident(
      id: "INC-001",
      title: "Building Fire — Block C",
      description:
          "Smoke reported on 3rd floor, sprinklers activated.",
      category: "Fire",
      priority: "Critical",
      status: "In Progress",
      location: "Block C, Main Campus",
      time: "22m ago",
    ),
    Incident(
      id: "INC-002",
      title: "Medical Emergency — Cafeteria",
      description:
          "Person collapsed, suspected cardiac event.",
      category: "Medical",
      priority: "Critical",
      status: "Reported",
      location: "Main Cafeteria",
      time: "7m ago",
    ),
    Incident(
      id: "INC-003",
      title: "Unauthorized Access — Server Room",
      description:
          "Badge reader triggered for unknown credential.",
      category: "Security",
      priority: "High",
      status: "In Progress",
      location: "IT Server Room B2",
      time: "1h ago",
    ),
    Incident(
      id: "INC-004",
      title: "Gas Leak — Parking Level 1",
      description:
          "Gas smell reported near east entrance.",
      category: "Hazmat",
      priority: "High",
      status: "Reported",
      location: "Parking Level 1 East",
      time: "12m ago",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: "Incidents",
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle),
            label: "Report",
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings),
            label: "Admin",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1A1F2E),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Emergency Response",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "All systems operational",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "2 Critical",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // ONLINE BANNER
            Container(
              width: double.infinity,
              color: Colors.green.shade100,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.wifi,
                    color: Colors.green.shade800,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Online — all data synced",
                    style: TextStyle(
                      color: Colors.green.shade900,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Simulate offline"),
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "OVERVIEW",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // DASHBOARD CARDS
                    GridView.count(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: [
                        dashboardCard(
                            "Total Incidents", "8",
                            Colors.blue),
                        dashboardCard(
                            "Active", "5",
                            Colors.orange),
                        dashboardCard(
                            "Resolved", "3",
                            Colors.green),
                        dashboardCard(
                            "Critical", "2",
                            Colors.red),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "PRIORITY DISTRIBUTION",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    priorityBar(
                        "Critical", 0.9, Colors.red),
                    priorityBar(
                        "High", 0.7, Colors.orange),
                    priorityBar(
                        "Medium", 0.5, Colors.blue),
                    priorityBar(
                        "Low", 0.3, Colors.green),

                    const SizedBox(height: 20),

                    const Text(
                      "RECENT INCIDENTS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // INCIDENT LIST
                    ...incidents.map(
                      (e) => incidentCard(e),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
      String title,
      String value,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget priorityBar(
      String label,
      double value,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              borderRadius:
                  BorderRadius.circular(20),
              backgroundColor:
                  Colors.grey.shade300,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget incidentCard(Incident incident) {
    Color priorityColor = Colors.green;

    if (incident.priority == "Critical") {
      priorityColor = Colors.red;
    } else if (incident.priority == "High") {
      priorityColor = Colors.orange;
    } else if (incident.priority == "Medium") {
      priorityColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(
            color: priorityColor,
            width: 5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            incident.id,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            incident.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 6,
            children: [
              chip(incident.priority, priorityColor),
              chip(incident.status, Colors.grey),
              chip(incident.category, Colors.black54),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            incident.description,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  incident.location,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Text(
                incident.time,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget chip(String text, Color color) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
    );
  }
}