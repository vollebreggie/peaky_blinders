import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/RoutineTaskSetting.dart';
import 'package:peaky_blinders/Repositories/RoutineSettingRepository.dart';

class RoutineSettingBloc implements BlocBase {
  List<RoutineTaskSetting> _routineSettings;
  RoutineTaskSetting _routineSetting;

  RoutineSettingBloc() {
    _routineSettings = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  Future syncRoutineSettings() async {
    await RoutineSettingRepository.get().syncProjectSettings();
  }

  Future setRoutineSettings() async {
    _routineSettings = await RoutineSettingRepository.get().getRoutineSettings();
  }

  List<RoutineTaskSetting> getRoutineTaskSettings() {
    return _routineSettings;
  }

  Future saveRoutineTask(RoutineTaskSetting task) async {
    await RoutineSettingRepository.get().createRoutineTask(task);
  }

  Future updateRoutineTask(RoutineTaskSetting task) async {
    await RoutineSettingRepository.get().updateRoutineTask(task);
  }

  Future changePriorityOfRoutineTask(before, after) async {
    RoutineTaskSetting task = _routineSettings[before];
    _routineSettings.removeAt(before);
    _routineSettings.insert(after, task);
    for (int i = 0; i < _routineSettings.length; i++) {
      _routineSettings[i].place = i;
    }

    await RoutineSettingRepository.get().changePriorityTasks(_routineSettings);
  }

  void setRoutineTask(RoutineTaskSetting task) {
    _routineSetting = task;
  }

  RoutineTaskSetting getRoutineTask() {
    return _routineSetting;
  }
}
