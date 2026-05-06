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
      title: 'Emergency Report',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      home: const ReportIncidentScreen(),
    );
  }
}

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() =>
      _ReportIncidentScreenState();
}

class _ReportIncidentScreenState
    extends State<ReportIncidentScreen> {
  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  String selectedCategory = "Select category...";
  String selectedPriority = "Low";

  final List<String> categories = [
    "Medical",
    "Fire",
    "Security",
    "Hazmat",
    "Infrastructure",
  ];

  final List<String> priorities = [
    "Critical",
    "High",
    "Medium",
    "Low",
  ];

  int currentIndex = 2;

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
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
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
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "NEW INCIDENT REPORT",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // INCIDENT TITLE
                    const Text(
                      "Incident title *",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller:
                          titleController,
                      decoration:
                          InputDecoration(
                        hintText:
                            "Brief, clear title...",
                        filled: true,
                        fillColor:
                            Colors.white,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      14),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // DESCRIPTION
                    const Text(
                      "Description *",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller:
                          descriptionController,
                      maxLines: 5,
                      decoration:
                          InputDecoration(
                        hintText:
                            "Describe what happened, who's affected, any immediate dangers...",
                        filled: true,
                        fillColor:
                            Colors.white,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      14),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // CATEGORY
                    const Text(
                      "Category *",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 16,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),
                      child:
                          DropdownButtonHideUnderline(
                        child:
                            DropdownButton<
                                String>(
                          isExpanded: true,
                          value:
                              selectedCategory,
                          items: [
                            const DropdownMenuItem(
                              value:
                                  "Select category...",
                              child: Text(
                                "Select category...",
                              ),
                            ),
                            ...categories.map(
                              (e) =>
                                  DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                          ],
                          onChanged:
                              (value) {
                            setState(() {
                              selectedCategory =
                                  value!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // PRIORITY
                    const Text(
                      "Priority *",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          priorities.map(
                        (priority) {
                          bool selected =
                              selectedPriority ==
                                  priority;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPriority =
                                    priority;
                              });
                            },
                            child: Container(
                              width: 150,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 14,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: selected
                                    ? priorityColor(
                                        priority)
                                    : Colors
                                        .white,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            14),
                              ),
                              alignment:
                                  Alignment
                                      .center,
                              child: Text(
                                priority,
                                style:
                                    TextStyle(
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

                    const SizedBox(height: 28),

                    // LOCATION
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    InkWell(
                      onTap: () {
                        locationController.text =
                            "Main Campus Block A";
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                          ),
                          const SizedBox(
                              width: 8),
                          const Text(
                            "Use simulated GPS location",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller:
                          locationController,
                      decoration:
                          InputDecoration(
                        hintText:
                            "Or enter location manually...",
                        filled: true,
                        fillColor:
                            Colors.white,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      14),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // OFFLINE WARNING
                    Container(
                      padding:
                          const EdgeInsets
                              .all(16),
                      decoration:
                          BoxDecoration(
                        color: const Color(
                            0xFFF3E8D4),
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.wifi_off,
                            color:
                                Colors.orange,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Offline — report will be queued and synced when connection restores.",
                              style: TextStyle(
                                color:
                                    Colors.brown,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SUBMIT BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Incident queued successfully",
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Queue report for sync",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              const Color(
                                  0xFF11182B),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        14),
                          ),
                        ),
                      ),
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
