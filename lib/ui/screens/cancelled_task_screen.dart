import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screens/task_summary_section.dart';
import 'package:task_manager_project/ui/widgets/task_card.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskListInProgress = false;
  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TaskSummarySection(),
        Expanded(
          child: Visibility(
            visible: !_getCancelledTaskListInProgress,
            replacement: const CenteredCircularProgressIndicator(),
            child: RefreshIndicator(
              onRefresh: () async {
                _getCancelledTaskList();
              },
              child: ListView.separated(
                itemCount: _cancelledTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: _cancelledTaskList[index],
                    onRefreshList: _getCancelledTaskList,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getCancelledTaskList() async {
    _cancelledTaskList.clear();
    _getCancelledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.cancelledTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _cancelledTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getCancelledTaskListInProgress = false;
    setState(() {});
  }
}