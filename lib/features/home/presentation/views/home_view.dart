import 'dart:async';
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
  List<TaskModel> searchList = [];
  bool showSearchTextFormFiled = false;
  Timer? _debounce;
  final _searchController = TextEditingController();

  void _filterTasks(String? taskName) {
    if (taskName!.isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () async => context.read<TaskCubit>().search(taskName),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getAllTasks();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {
          if (state is GetAllTasksSuccess) {
            tasks = state.tasks;
            if (state.tasks.isNotEmpty) {
              showSearchTextFormFiled = true;
            } else {
              showSearchTextFormFiled = false;
            }
          } else if (state is GetAllTasksFailure) {
            showCustomToast(
              context: context,
              message: state.errorMessage,
              contentType: ContentType.failure,
            );
          } else if (state is SearchTaskSuccess) {
            searchList = state.tasks;
          } else if (state is EditTaskFailure) {
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
                  state is GetAllTasksSuccess ||
                          state is GetAllTasksLoading ||
                          state is SearchTaskSuccess ||
                          state is SearchTaskLoading
                      ? tasks.isEmpty && state is GetAllTasksSuccess
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
                                        !showSearchTextFormFiled
                                            ? const LoadingTextFormField()
                                            : TextFormFieldHelper(
                                                controller: _searchController,
                                                hint: 'Search for your task...',
                                                prefixIcon: SvgPicture.asset(
                                                  'assets/icons/search-icon.svg',
                                                  height: 24.h,
                                                  width: 24.w,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                                contentPadding: EdgeInsets.all(
                                                  12.r,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                borderColor:
                                                    ColorsManager.color6E6A7C,
                                                action: TextInputAction.search,
                                                onChanged: _filterTasks,
                                                suffixWidget:
                                                    _searchController
                                                        .text
                                                        .isNotEmpty
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          _searchController
                                                              .clear();
                                                          setState(() {});
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: ColorsManager
                                                              .color6E6A7C,
                                                          size: 22.r,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                        Gap(26.h),
                                        state is GetAllTasksLoading ||
                                                state is SearchTaskLoading
                                            ? const LoadingTasksListView()
                                            : Expanded(
                                                child: TasksListView(
                                                  tasks:
                                                      _searchController
                                                          .text
                                                          .isNotEmpty
                                                      ? searchList
                                                      : tasks,
                                                ),
                                              ),
                                      ],
                                    ),
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
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
          ? AddTaskFloatingActionButton(
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
            )
          : null,
    );
  }
}
