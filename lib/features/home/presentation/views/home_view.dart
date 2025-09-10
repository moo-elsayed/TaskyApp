import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/core/widgets/custom_toast.dart';
import 'package:tasky_app/core/widgets/text_form_field_helper.dart';
import 'package:tasky_app/features/home/data/models/task.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_cubit.dart';
import 'package:tasky_app/features/home/presentation/widgets/add_task_bottom_sheet.dart';
import 'package:tasky_app/features/home/presentation/widgets/loading_text_form_filed.dart';
import '../../../../core/helpers/dependency_injection.dart';
import '../../data/repos/task_repo_imp.dart';
import '../managers/cubits/add_task_cubit/add_task_cubit.dart';
import '../managers/cubits/task_cubit/task_states.dart';
import '../widgets/loading_tasks_list_view.dart';
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
              child: Column(
                children: [
                  const HomeAppBar(),
                  state is GetAllTasksSuccess
                      ? tasks.isEmpty
                            ? const NoTasksBody()
                            : Expanded(
                                child: GestureDetector(
                                  onTap: () => FocusScope.of(context).unfocus(),
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    child: Column(
                                      children: [
                                        Gap(26.h),
                                        TextFormFieldHelper(
                                          hint: 'Search for your task...',
                                          prefixIcon: SvgPicture.asset(
                                            'assets/icons/search-icon.svg',
                                            height: 24.h,
                                            width: 24.w,
                                            fit: BoxFit.scaleDown,
                                          ),
                                          contentPadding: EdgeInsets.all(12.r),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          borderColor:
                                              ColorsManager.color6E6A7C,
                                          action: TextInputAction.search,
                                        ),
                                        Gap(26.h),
                                        Expanded(
                                          child: TasksListView(tasks: tasks),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                      : state is GetAllTasksLoading
                      ? Expanded(
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 12.w,
                            ),
                            child: Column(
                              children: [
                                Gap(26.h),
                                const LoadingTextFormField(),
                                Gap(26.h),
                                const Expanded(child: LoadingTasksListView()),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
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
