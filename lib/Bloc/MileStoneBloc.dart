import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Models/MileStoneDropdown.dart';
import 'package:peaky_blinders/Repositories/MileStoneRepository.dart';

class MileStoneBloc implements BlocBase {
  List<MileStone> milestones;
  MileStone _currentMilestone;
  bool counter;

  StreamController<List<MileStone>> _milestoneController =
      StreamController<List<MileStone>>.broadcast();
  StreamSink<List<MileStone>> get _inMileStone => _milestoneController.sink;
  Stream<List<MileStone>> get outMileStone => _milestoneController.stream;

  StreamController<List<MileStoneDropdown>> _milestoneDropdownController =
      StreamController<List<MileStoneDropdown>>.broadcast();
  StreamSink<List<MileStoneDropdown>> get _inMileStoneDropdown =>
      _milestoneDropdownController.sink;
  Stream<List<MileStoneDropdown>> get outMileStoneDropdown =>
      _milestoneDropdownController.stream;
  //
  // Constructor
  //
  MileStoneBloc() {
    counter = false;
    milestones = null;
    //MileStoneRepository.get().syncProjects();
  }

  @override
  void dispose() {
    _milestoneDropdownController.close();
    _milestoneController.close();
  }

  Future syncMilestonesByProjectId(projectId) async {
    await MileStoneRepository.get().syncMilestonesByProjectId(projectId);
  }

  void syncCurrentMilestone() async {
    await MileStoneRepository.get().syncMilestone(_currentMilestone.id);
    milestones = await MileStoneRepository.get()
        .getMilestonesByProjectId(_currentMilestone.projectId);
    print("milestones");
  }

  void setCurrentMileStone(MileStone milestone) {
    _currentMilestone = milestone;
  }

  MileStone getCurrentMileStone() {
    return _currentMilestone;
  }

  Future getDropdownMileStone(int projectId) async {
    _inMileStoneDropdown
        .add(await MileStoneRepository.get().getMileStoneDropdown(projectId));
  }

  Future getMilestones(projectId) async {
    _inMileStone.add(
        await MileStoneRepository.get().getMilestonesByProjectId(projectId));
  }

  Future getMilestonesByProjectId(projectId) async {
    if (milestones == null) {
      milestones =
          await MileStoneRepository.get().getMilestonesByProjectId(projectId);
    }
  }

  /// delete milestone from project
  /// param: milestone id
  Future deleteMileStoneById(int milestoneId) async {
    await MileStoneRepository.get().deleteMileStoneByIdAsync(milestoneId);
  }

  void createMileStone(projectId) {
    MileStone milestone = new MileStone(
        id: 0,
        title: "New Milestone",
        place: milestones.length,
        tasks: [],
        projectId: projectId);
    milestones.add(milestone);
    //MileStoneRepository.get().createMilestone(milestone);
  }

  void removeMileStone() {}

  void updateMileStones(projectId) {
    MileStoneRepository.get().updateMilestones(milestones);
    syncMilestonesByProjectId(projectId);
  }
}
