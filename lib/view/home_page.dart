import 'package:adv_flutter_final_exam/service/cloud_firestore.dart';
import 'package:adv_flutter_final_exam/service/google_auth_servide.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../provider/habit_provider.dart';

TextEditingController txtName = TextEditingController();
TextEditingController txtTargetDays = TextEditingController();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    HabitProvider habitProviderTrue =
        Provider.of<HabitProvider>(context, listen: true);
    HabitProvider habitProviderFalse =
        Provider.of<HabitProvider>(context, listen: false);
    habitProviderFalse.calculateProgress();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        bottom: PreferredSize(
          preferredSize: const Size(100, 40),
          child: Row(
            children: [
              TextButton(
                  onPressed: () async {
                    await habitProviderFalse.syncDataCloudToDatabase();
                  },
                  child: const Text(
                    "Save to local",
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                onPressed: () async {
                  await CloudFireStoreService.cloudFireStoreService
                      .insertDataIntoFireStore(habitProviderTrue.data);
                },
                child: const Text(
                  "Backup",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await GoogleAuthService.googleAuthService.signOutFromGoogle();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Progress"),
                const Gap(20),
                Consumer<HabitProvider>(
                  builder: (BuildContext context, value, Widget? child) => Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 85,
                        width: 85,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey.shade300,
                          value: value.per > 0 ? value.per / 100 : 0.0,
                          strokeWidth: 8,
                          color: Colors.blue,
                        ),
                      ),
                      Text("${habitProviderTrue.per.toStringAsFixed(2)}%")
                    ],
                  ),
                ),
              ],
            ),
            const Gap(20),
            const Text("Habits"),
            Expanded(
              child: ListView.builder(
                itemCount: habitProviderTrue.data.length,
                itemBuilder: (context, index) {
                  final data = habitProviderTrue.data[index];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(data.habitName),
                          subtitle: Text(data.targetDays),
                          leading: Text(data.id.toString()),
                          trailing: Text(data.progress),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            txtName.text = data.habitName;
                            txtTargetDays.text = data.targetDays;
                            habitProviderFalse.setProgress("Complete");
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Add Note"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(controller: txtName),
                                      const Gap(20),
                                      TextField(controller: txtTargetDays),
                                      Consumer<HabitProvider>(
                                        builder: (BuildContext context,
                                                HabitProvider provider,
                                                Widget? child) =>
                                            Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Radio(
                                                    value: "Complete",
                                                    groupValue:
                                                        provider.groupValue,
                                                    onChanged: (value) {
                                                      habitProviderFalse
                                                          .setProgress(value!);
                                                    }),
                                                const Text('Complete'),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Radio(
                                                    value: "NotComplete",
                                                    groupValue:
                                                        provider.groupValue,
                                                    onChanged: (value) {
                                                      habitProviderFalse
                                                          .setProgress(value!);
                                                    }),
                                                const Text('NotComplete'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Cancel")),
                                    TextButton(
                                        onPressed: () async {
                                          if (txtTargetDays.text != "" &&
                                              txtName.text != "") {
                                            await habitProviderFalse.updateData(
                                                data.id,
                                                txtName.text,
                                                txtTargetDays.text,
                                                habitProviderTrue.groupValue);
                                            Navigator.pop(context);
                                          } else {
                                            // print("All Field Must Be Required");
                                          }
                                          habitProviderFalse
                                              .calculateProgress();
                                        },
                                        child: const Text("Ok")),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                        onPressed: () => habitProviderFalse.deleteData(data.id),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          clearController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Habit"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: txtName,
                      decoration: const InputDecoration(
                          labelText: "HabitName", border: OutlineInputBorder()),
                    ),
                    const Gap(20),
                    TextField(
                      controller: txtTargetDays,
                      decoration: const InputDecoration(
                          labelText: "Target Days",
                          border: OutlineInputBorder()),
                    ),
                    Consumer<HabitProvider>(
                      builder: (BuildContext context, HabitProvider provider,
                              Widget? child) =>
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                  value: "Complete",
                                  groupValue: provider.groupValue,
                                  onChanged: (value) {
                                    habitProviderFalse.setProgress(value!);
                                  }),
                              const Text("Complete"),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                  value: "NotComplete",
                                  groupValue: provider.groupValue,
                                  onChanged: (value) {
                                    habitProviderFalse.setProgress(value!);
                                  }),
                              const Text("NotComplete"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () async {
                        habitProviderTrue.id =
                            habitProviderTrue.data.length + 1;
                        if (txtTargetDays.text != "" && txtName.text != "") {
                          await habitProviderFalse.insertData(
                              habitProviderTrue.id,
                              txtName.text,
                              txtTargetDays.text,
                              habitProviderTrue.groupValue);
                          Navigator.pop(context);
                        } else {
                          // print("All Field Must Be Required");
                        }
                        habitProviderFalse.calculateProgress();
                      },
                      child: const Text("Ok")),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

void clearController() {
  txtName.clear();
  txtTargetDays.clear();
}
