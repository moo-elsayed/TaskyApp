import 'dart:async';
import 'dart:developer';
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
import 'package:tasky_app/features/home/presentation/widgets/custom_dropdown_list.dart';
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
  List<TaskModel> uncompletedTasks = [];
  List<TaskModel> completedTasks = [];
  List<TaskModel> tasks = [];
  List<TaskModel> searchList = [];
  final List<DateTime> _days = List.generate(
    10,
    (index) => DateTime.now()
        .subtract(const Duration(days: 3))
        .add(Duration(days: index)),
  );
  late DateTime _currentDay = _days[3];
  Timer? _debounce;
  final _searchController = TextEditingController();

  void _buildOnChanged(String? text) {
    if (text != null && text.trim().isNotEmpty) {
      _filterTasks(text);
    } else {
      context.read<TaskCubit>().getTasks(_currentDay);
    }
  }

  void _filterTasks(String taskName) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (_searchController.text.trim() == taskName.trim() &&
          taskName.isNotEmpty) {
        log(taskName);
        context.read<TaskCubit>().search(taskName);
      }
    });
  }

  void getTasksByCategory() {
    uncompletedTasks = tasks
        .where((task) => task.isCompleted == false)
        .toList();
    completedTasks = tasks.where((task) => task.isCompleted == true).toList();
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getTasks(_currentDay);
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
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {
          if (state is GetTasksSuccess) {
            tasks = state.tasks;
            getTasksByCategory();
          } else if (state is GetTasksFailure) {
            showCustomToast(
              context: context,
              message: state.errorMessage,
              contentType: ContentType.failure,
            );
          } else if (state is SearchTaskSuccess) {
            searchList = state.tasks;
          }
        },
        builder: (context, state) {
          if (state is GetTasksSuccess) {
            return SafeArea(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: buildPadding(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeAppBar(),
                      Gap(16.h),
                      TextFormFieldHelper(
                        controller: _searchController,
                        hint: 'Search for your task...',
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/search-icon.svg',
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.scaleDown,
                        ),
                        contentPadding: EdgeInsets.all(12.r),
                        borderRadius: BorderRadius.circular(10.r),
                        borderColor: ColorsManager.color6E6A7C,
                        action: TextInputAction.search,
                        onChanged: _buildOnChanged,
                        suffixWidget: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  context.read<TaskCubit>().getTasks(
                                    _currentDay,
                                  );
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: ColorsManager.color6E6A7C,
                                  size: 22.r,
                                ),
                              )
                            : null,
                      ),
                      Gap(16.h),
                      CustomDropdownList(
                        days: _days,
                        currentDay: _currentDay,
                        onChanged: (value) {
                          _currentDay = value!;
                          setState(() {});
                        },
                      ),
                      completedTasks.length + uncompletedTasks.length == 0
                          ? const NoTasksBody()
                          : Expanded(
                              child: TasksListView(
                                completedTasks: completedTasks,
                                uncompletedTasks: uncompletedTasks,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is SearchTaskSuccess) {
            return SafeArea(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: buildPadding(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeAppBar(),
                      Gap(16.h),
                      TextFormFieldHelper(
                        controller: _searchController,
                        hint: 'Search for your task...',
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/search-icon.svg',
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.scaleDown,
                        ),
                        contentPadding: EdgeInsets.all(12.r),
                        borderRadius: BorderRadius.circular(10.r),
                        borderColor: ColorsManager.color6E6A7C,
                        action: TextInputAction.search,
                        onChanged: _buildOnChanged,
                        suffixWidget: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  context.read<TaskCubit>().getTasks(
                                    _currentDay,
                                  );
                                  _searchController.clear();
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: ColorsManager.color6E6A7C,
                                  size: 22.r,
                                ),
                              )
                            : null,
                      ),
                      Gap(16.h),
                      searchList.isEmpty
                          ? const NoTasksBody()
                          : Expanded(
                              child: TasksListView(searchResults: searchList),
                            ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is GetTasksLoading || state is SearchTaskLoading) {
            return SafeArea(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: buildPadding(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeAppBar(),
                      Gap(16.h),
                      TextFormFieldHelper(
                        controller: _searchController,
                        hint: 'Search for your task...',
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/search-icon.svg',
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.scaleDown,
                        ),
                        contentPadding: EdgeInsets.all(12.r),
                        borderRadius: BorderRadius.circular(10.r),
                        borderColor: ColorsManager.color6E6A7C,
                        action: TextInputAction.search,
                        onChanged: _buildOnChanged,
                        suffixWidget: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  context.read<TaskCubit>().getTasks(
                                    _currentDay,
                                  );
                                  _searchController.clear();
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: ColorsManager.color6E6A7C,
                                  size: 22.r,
                                ),
                              )
                            : null,
                      ),
                      Gap(16.h),
                      if (state is GetTasksLoading)
                        CustomDropdownList(
                          days: _days,
                          currentDay: _currentDay,
                          onChanged: (value) {
                            _currentDay = value!;
                            setState(() {});
                          },
                        ),
                      const LoadingTasksListView(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
          ? AddTaskFloatingActionButton(
              // opacity: tasks.length >= 7 ? 0.7 : 1,
              opacity: 1,
              onPressed: () {
                TextEditingController().clear();
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

  EdgeInsets buildPadding() =>
      EdgeInsets.only(right: 24.w, left: 24.w, top: 12.h);

  Padding buildNoTasksFound() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 24.h),
      child: const Align(
        alignment: AlignmentGeometry.center,
        child: Text('No tasks found'),
      ),
    );
  }
}
