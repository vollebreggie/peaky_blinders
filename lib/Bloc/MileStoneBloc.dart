import 'dart:async';

import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/MileStone.dart';
import 'package:peaky_blinders/Repositories/MileStoneRepository.dart';

class MileStoneBloc implements BlocBase {
  List<MileStone> milestones;
  MileStone _currentMilestone;
  bool counter;

  StreamController<List<MileStone>> _milestoneController =
      StreamController<List<MileStone>>.broadcast();
  StreamSink<List<MileStone>> get _inMileStone => _milestoneController.sink;
  Stream<List<MileStone>> get outMileStone => _milestoneController.stream;

  StreamController _actionController = StreamController();
  StreamSink get fetchProject => _actionController.sink;

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
    _actionController.close();
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
