import 'package:flutter/material.dart';

void main() {
  runApp(const EmergencyAdminApp());
}

class EmergencyAdminApp extends StatelessWidget {
  const EmergencyAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Response',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      home: const AdminDashboardScreen(),
    );
  }
}

class Incident {
  final String id;
  final String title;
  final String category;
  final String time;
  final String location;
  String status;
  String responder;
  String priority;

  Incident({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.location,
    required this.status,
    required this.responder,
    required this.priority,
  });
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {
  int currentIndex = 3;

  final List<String> statusOptions = [
    "Reported",
    "In Progress",
    "Resolved",
  ];

  final List<String> responders = [
    "Unassigned",
    "Unit Alpha-7",
    "Unit Bravo-2",
    "Medical Team",
  ];

  final List<String> priorities = [
    "Critical",
    "High",
    "Medium",
    "Low",
  ];

  final List<Incident> incidents = [
    Incident(
      id: "INC-009",
      title: "GHGN",
      category: "Security",
      time: "24m ago",
      location:
          "Main Gate (GPS: 23.4209°N, 72.5530°E)",
      status: "Reported",
      responder: "Unit Alpha-7",
      priority: "Low",
    ),
    Incident(
      id: "INC-002",
      title: "Medical Emergency — Cafeteria",
      category: "Medical",
      time: "30m ago",
      location: "Main Cafeteria",
      status: "Reported",
      responder: "Unassigned",
      priority: "Low",
    ),
    Incident(
      id: "INC-004",
      title: "Gas Leak — Parking Level 1",
      category: "Hazmat",
      time: "35m ago",
      location: "Parking Level 1 East",
      status: "Reported",
      responder: "Unassigned",
      priority: "Low",
    ),
    Incident(
      id: "INC-001",
      title: "Building Fire — Block C",
      category: "Fire",
      time: "45m ago",
      location: "Block C, Main Campus",
      status: "In Progress",
      responder: "Unit Alpha-7",
      priority: "Low",
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: "Incidents",
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: "Report",
          ),
          NavigationDestination(
            icon:
                Icon(Icons.admin_panel_settings_outlined),
            selectedIcon:
                Icon(Icons.admin_panel_settings),
            label: "Admin",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              color: const Color(0xFF11182B),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emergency Response",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Offline mode active",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "0 Critical",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // OFFLINE BANNER
            Container(
              width: double.infinity,
              color: const Color(0xFFF3E8D4),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 18,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Offline — 0 report(s) queued for sync",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Restore connection",
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.all(20),
                children: [
                  const Text(
                    "ADMIN — MANAGE INCIDENTS",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ...incidents.map(
                    (incident) =>
                        incidentCard(incident),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget incidentCard(Incident incident) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      incident.id,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      incident.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${incident.category} • ${incident.time} • ${incident.location}",
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              priorityChip(
                  incident.priority),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 14,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .grey.shade100,
                        borderRadius:
                            BorderRadius
                                .circular(
                                    12),
                      ),
                      child:
                          DropdownButtonHideUnderline(
                        child:
                            DropdownButton<
                                String>(
                          value:
                              incident.status,
                          isExpanded: true,
                          items:
                              statusOptions
                                  .map(
                            (status) =>
                                DropdownMenuItem(
                              value: status,
                              child:
                                  Text(status),
                            ),
                          ).toList(),
                          onChanged:
                              (value) {
                            setState(() {
                              incident.status =
                                  value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Responder",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 14,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .grey.shade100,
                        borderRadius:
                            BorderRadius
                                .circular(
                                    12),
                      ),
                      child:
                          DropdownButtonHideUnderline(
                        child:
                            DropdownButton<
                                String>(
                          value:
                              incident
                                  .responder,
                          isExpanded: true,
                          items:
                              responders.map(
                            (responder) =>
                                DropdownMenuItem(
                              value:
                                  responder,
                              child: Text(
                                  responder),
                            ),
                          ).toList(),
                          onChanged:
                              (value) {
                            setState(() {
                              incident.responder =
                                  value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Priority override",
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: priorities.map(
              (priority) {
                bool selected =
                    incident.priority ==
                        priority;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      incident.priority =
                          priority;
                    });
                  },
                  child: Container(
                    width: 100,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 12,
                    ),
                    decoration:
                        BoxDecoration(
                      color: selected
                          ? priorityColor(
                              priority)
                          : Colors
                              .grey.shade100,
                      borderRadius:
                          BorderRadius
                              .circular(
                                  12),
                    ),
                    alignment:
                        Alignment.center,
                    child: Text(
                      priority,
                      style: TextStyle(
                        color: selected
                            ? Colors
                                .white
                            : Colors
                                .black,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget priorityChip(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color:
            priorityColor(text)
                .withValues(alpha: 0.15),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: priorityColor(text),
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  Color priorityColor(String priority) {
    switch (priority) {
      case "Critical":
        return Colors.red;

      case "High":
        return Colors.orange;

      case "Medium":
        return Colors.blue;

      default:
        return Colors.green;
    }
  }
}