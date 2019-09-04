import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';
import 'package:peaky_blinders/Models/Master.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/Project.dart';
import 'package:peaky_blinders/Models/Reason.dart';
import 'package:peaky_blinders/Models/Problem.dart';
import 'package:peaky_blinders/Models/User.dart';
import 'package:peaky_blinders/Repositories/PersonalRepository.dart';
import 'package:peaky_blinders/Repositories/ProblemRepository.dart';
import 'package:peaky_blinders/Repositories/ProjectRepository.dart';

class ProblemBloc implements BlocBase {
  List<Problem> _problems;
  Problem _problem;

  PersonalBloc() {
    _problems = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  List<Problem> getProblems() {
    return _problems;
  }

  void setProblem(Problem problem) {
    _problem = problem;
  }

  Problem getCurrentProblem() {
    return _problem;
  }

  Future syncProblem() async {
    await ProblemRepository.get().syncProblems();
  }

  Future setProblems() async {
    this._problems = await ProblemRepository.get().getProblems();
  }

  Future setAllProblemsByProject(int projectId) async {
    this._problems =
        await ProblemRepository.get().getAllProblemsForProjectById(projectId);
  }

  int getProblemCount() {
    if (_problems == null) return 0;
    return _problems.length;
  }

  String getImageFromServer(image) {
    return ProblemRepository.get().weburl +
        "images/" +
        (image != null ? image : "example.jpg");
  }

  Future changePriorityOfProblem(before, after) async {
    Problem problem = _problems[before];
    _problems.removeAt(before);
    problem.place = after;
    _problems.insert(after, problem);
    for (int i = 0; i < _problems.length; i++) {
      _problems[i].place = i;
    }
    await ProblemRepository.get().changePriorityProblems(_problems);
  }

  Future updateCurrentImage() async {
    _problem.imagePath = await ProblemRepository.get().getImageProblem(_problem);
  }

  Future updateImage(File image, Problem problem) async {
    await ProblemRepository.get().postProblemWithImage(image, problem);
  }

  Future updateProblem(Problem problem) async {
    await ProblemRepository.get().updateProblem(problem);
  }

  Future createProblem(Problem problem) async {
    await ProblemRepository.get().createProblem(problem);
    await setProblems();
  }

  Future postProblem(File image, Problem problem) async {
    
    await ProblemRepository.get().postProblem(image, problem);
  }

  Future removeProblem(Problem problem) async {
    _problems.remove(problem);
    await ProblemRepository.get().removeProblem(problem);
  }
}
