import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/models/task_status_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_summary_card.dart';

class TaskSummarySection extends StatefulWidget {
  const TaskSummarySection({Key? key}) : super(key: key);

  @override
  _TaskSummarySectionState createState() => _TaskSummarySectionState();
}

class _TaskSummarySectionState extends State<TaskSummarySection> {
  bool _isLoading = true;
  List<TaskStatusModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getTaskStatusCount();
  }

  Future<void> _getTaskStatusCount() async {

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskStatusCount);

    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel =
      TaskStatusCountModel.fromJson(response.responseData);
      setState(() {
        _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
        _isLoading = false;
      });
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<TaskSummaryCard> _getTaskSummaryCardList() {
    return _taskStatusCountList.map((taskStatus) {
      return TaskSummaryCard(
        title: taskStatus.sId!,
        count: taskStatus.sum ?? 0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !_isLoading,
        replacement: const CenteredCircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _getTaskSummaryCardList(),
          ),
        ),
      ),
    );
  }
}