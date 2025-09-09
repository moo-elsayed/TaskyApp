import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/core/widgets/custom_toast.dart';
import 'package:tasky_app/features/home/data/models/task.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_cubit.dart';
import 'package:tasky_app/features/home/presentation/widgets/add_task_bottom_sheet.dart';
import '../../../../core/helpers/dependency_injection.dart';
import '../../data/repos/task_repo_imp.dart';
import '../managers/cubits/add_task_cubit/add_task_cubit.dart';
import '../managers/cubits/task_cubit/task_states.dart';
import '../widgets/add_task_floating_action_button.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/no_tasks_body.dart';
import '../widgets/tasks_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {
          if (state is GetAllTasksSuccess) {
            tasks = state.tasks;
          }
          if (state is GetAllTasksFailure) {
            showCustomToast(
              context: context,
              message: state.errorMessage,
              contentType: ContentType.failure,
            );
          }
          if (state is EditTaskFailure) {
            showCustomToast(
              context: context,
              message: state.errorMessage,
              contentType: ContentType.failure,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(right: 12.w, left: 12.w, top: 12.h),
              child: RefreshIndicator(
                onRefresh: () => context.read<TaskCubit>().getAllTasks(),
                child: Column(
                  children: [
                    const HomeAppBar(),
                    state is GetAllTasksSuccess
                        ? tasks.isEmpty
                              ? const NoTasksBody()
                              : Expanded(child: TasksListView(tasks: tasks))
                        : state is GetAllTasksLoading
                        ? const Expanded(
                            child: Center(child: CupertinoActivityIndicator()),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: AddTaskFloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: ColorsManager.white,
            isScrollControlled: true,
            context: context,
            builder: (context) => BlocProvider(
              create: (context) =>
                  AddTaskCubit(getIt.get<TaskRepositoryImplementation>()),
              child: const AddTaskBottomSheet(),
            ),
          );
        },
      ),
    );
  }
}
