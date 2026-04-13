import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ToDoScreen(),
    );
  }
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Map<String, dynamic>> tasks = [
    {
      'title': 'Study Flutter course',
      'descriptions': [
        {'text': 'Review lecture slides', 'isDone': true},
        {'text': 'Solve examples', 'isDone': true},
        {'text': 'Review assignments', 'isDone': false},
      ],
    },
  ];
  TextEditingController titleController = TextEditingController();

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        List<Map<String, dynamic>> newDescriptions = [];
        TextEditingController descController = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Task'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter To-Do title',
                    ),
                  ),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(hintText: 'Enter task'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (descController.text.isNotEmpty) {
                        newDescriptions.add({
                          'text': descController.text,
                          'isDone': false,
                        });
                        descController.clear();
                        setStateDialog(() {});
                      }
                    },
                    child: const Text('Add task'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    newDescriptions.isNotEmpty) {
                  setState(() {
                    tasks.add({
                      'title': titleController.text,
                      'descriptions': newDescriptions,
                    });
                    titleController.clear();
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleDescription(int taskIndex, int descIndex) {
    setState(() {
      bool current = tasks[taskIndex]['descriptions'][descIndex]['isDone'];
      tasks[taskIndex]['descriptions'][descIndex]['isDone'] = !current;
    });
  }

  int _getPendingTasksCount() {
    return tasks
        .expand((task) => task['descriptions'] as List)
        .where((desc) => !(desc['isDone'] as bool))
        .length;
  }

  int _getDoneTasksCount() {
    return tasks
        .expand((task) => task['descriptions'] as List)
        .where((desc) => desc['isDone'] as bool)
        .length;
  }

  int _getTotalTasksCount() {
    return _getPendingTasksCount() + _getDoneTasksCount();
  }

  int _getCompletedToDosCount() {
    return tasks.where((task) {
      final descriptions = task['descriptions'] as List;
      return descriptions.every((desc) => desc['isDone'] as bool);
    }).length;
  }

  int _getTotalToDosCount() {
    return tasks.length;
  }

  double _getToDosProgress() {
    final totalToDos = _getTotalToDosCount();
    final completedToDos = _getCompletedToDosCount();
    return totalToDos > 0 ? completedToDos / totalToDos : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final toDosProgress = _getToDosProgress();
    final totalTasks = _getTotalTasksCount();
    final tasksProgress = totalTasks > 0
        ? _getDoneTasksCount() / totalTasks
        : 0.0;

    if (screenWidth > 1000) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
          child: Row(
            children: [
              HalfLeftPartOfTablet(context, toDosProgress, tasksProgress),
              HalfRightPartOfTablet(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Text(
            'To-Do',
            style: TextStyle(
              color: Color(0xFF4283B5),
              fontSize: 24,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: profileRow(),
            ),
            pendingContainer(context, _getPendingTasksCount()),
            doneContainer(context, _getDoneTasksCount()),
            const Text(
              'My To-Dos',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            const SizedBox(height: 8),
            ListOfToDos(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 44,
          height: 44,
          child: FloatingActionButton(
            onPressed: _addTask,
            backgroundColor: const Color(0xFF4283B5),
            child: const Icon(Icons.add, color: Color(0xffF2F9FE), size: 20),
          ),
        ),
      ),
    );
  }

  Expanded HalfRightPartOfTablet() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFFFF),
        ),
        width: 735,
        height: 678,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16, right: 32),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        'My To-Dos',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(),
                  margin: const EdgeInsets.only(),
                  child: SizedBox(
                    width: 149,
                    height: 40,
                    child: FloatingActionButton.extended(
                      onPressed: _addTask,
                      backgroundColor: const Color(0xFF4283B5),
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xffF2F9FE),
                        size: 24,
                      ),
                      label: const Text(
                        "Add To-Do",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Color(0xffF2F9FE),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GridOf_2_InROW(),
          ],
        ),
      ),
    );
  }

  Expanded GridOf_2_InROW() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 174,
          childAspectRatio: 1,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, taskIndex) {
          final task = tasks[taskIndex];
          final descriptions = task['descriptions'] as List;
          final ScrollController scrollController = ScrollController();

          return Container(
            width: 351.5,
            height: 174,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x1a4283B5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'],
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff191d20),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.list,
                              color: Color(0xff8F99A2),
                              size: 15,
                            ),
                            Text(
                              '${descriptions.length} Tasks',
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12,
                                color: Color(0xff8F99A2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          tasks.removeAt(taskIndex);
                        });
                        scrollController.dispose();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xff852221),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Color(0xff852221),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Expanded(
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: descriptions.asMap().entries.map((entry) {
                          int descIndex = entry.key;
                          var desc = entry.value;
                          return InkWell(
                            onTap: () =>
                                _toggleDescription(taskIndex, descIndex),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    size: 15,
                                    desc['isDone']
                                        ? Icons.task_alt_outlined
                                        : Icons.circle_outlined,
                                    color: desc['isDone']
                                        ? const Color(0xff42B570)
                                        : const Color(0xff8F99A2),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      desc['text'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: desc['isDone']
                                            ? const Color(0xff42B570)
                                            : const Color(0xff8F99A2),
                                        decoration: desc['isDone']
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container HalfLeftPartOfTablet(
    BuildContext context,
    double toDosProgress,
    double tasksProgress,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        shape: BoxShape.rectangle,
        color: const Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: const Color(0x2A2A2A40),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0x2A2A2A40), width: 2),
      ),
      width: 449,
      height: 678,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
            child: const Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                'To-Do',
                style: TextStyle(
                  color: Color(0xFF4283B5),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
            child: profileRow(),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.14,
            decoration: BoxDecoration(
              color: const Color(0xffb58742),
              borderRadius: BorderRadius.circular(20),
            ),
            child: pendingTablet(),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.14,
            decoration: BoxDecoration(
              color: const Color(0xff42b570),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DoneTablet(),
          ),
          ToDosAndTasks(toDosProgress, tasksProgress),
        ],
      ),
    );
  }

  Row ToDosAndTasks(double toDosProgress, double tasksProgress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 32),
          width: 176.5,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECF3F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'To-Dos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 85,
                height: 85,
                child: CircularProgressIndicator(
                  value: toDosProgress,
                  strokeCap: StrokeCap.round,
                  backgroundColor: const Color(0xFFD3DCE6),
                  color: const Color(0xFF4283B5),
                  strokeWidth: 10,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: const Color(0xFF4283B5),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff191D20),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: const Color(0xFFD3DCE6),
                  ),
                  const SizedBox(width: 4),
                  const Text('Pending'),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 32),
          width: 176.5,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECF3F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 85,
                height: 85,
                child: CircularProgressIndicator(
                  value: tasksProgress,
                  strokeCap: StrokeCap.round,
                  backgroundColor: const Color(0xFFD3DCE6),
                  color: const Color(0xFF4283B5),
                  strokeWidth: 10,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: const Color(0xFF4283B5),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff191D20),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: const Color(0xFFD3DCE6),
                  ),
                  const SizedBox(width: 4),
                  const Text('Pending'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column DoneTablet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 61, 155, 99),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const Text(
              'Done',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            '${_getDoneTasksCount()} Tasks',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Column pendingTablet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 164, 123, 60),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.autorenew, color: Colors.white, size: 20),
            ),
            const Text(
              'Pending',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            '${_getPendingTasksCount()} Tasks',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Expanded ListOfToDos() {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, taskIndex) {
          final task = tasks[taskIndex];
          final descriptions = task['descriptions'] as List;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x1a4283B5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff191d20),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.list,
                              color: Color(0xff8F99A2),
                              size: 15,
                            ),
                            Text(
                              '${descriptions.length} Tasks',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff8F99A2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          tasks.removeAt(taskIndex);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xff852221),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Color(0xff852221),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Column(
                  children: descriptions.asMap().entries.map((entry) {
                    int descIndex = entry.key;
                    var desc = entry.value;

                    return InkWell(
                      onTap: () => _toggleDescription(taskIndex, descIndex),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              size: 15,
                              desc['isDone']
                                  ? Icons.task_alt_outlined
                                  : Icons.circle_outlined,
                              color: desc['isDone']
                                  ? Color(0xff42B570)
                                  : Color(0xff8F99A2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              desc['text'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: desc['isDone']
                                    ? Color(0xff42B570)
                                    : Color(0xff8F99A2),
                                decoration: desc['isDone']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container pendingContainer(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      decoration: BoxDecoration(
        color: const Color(0xffb58742),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 164, 123, 60),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.autorenew,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Text(
                'Pending',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              '$count Tasks',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container doneContainer(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      decoration: BoxDecoration(
        color: const Color(0xff42b570),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 61, 155, 99),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
              const Text(
                'Done',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              '$count Tasks',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row profileRow() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/profile_image.jpg'),
            radius: 25,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Good morning,Sara',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Have a wonderful day!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff8F99A2),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0x1a4283B5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: const Color(0x1a4283B5)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xff4283B5),
            size: 25,
          ),
        ),
      ],
    );
  }
}
