import 'dart:async';
import 'package:flutter/material.dart';
import '../models/tutorial_step.dart';
import '../models/tutorial_config.dart';

/// Callback function types
typedef TutorialCallback = void Function();
typedef StepCallback = void Function(int stepIndex);

/// Controller for managing tutorial state and navigation
class TutorialController extends ChangeNotifier {
  final List<TutorialStep> _steps = [];
  final TutorialConfig _config;
  
  int _currentStepIndex = 0;
  bool _isActive = false;
  bool _isPaused = false;
  Timer? _autoPlayTimer;

  /// Tutorial completion callback
  TutorialCallback? onComplete;

  /// Tutorial skip callback
  TutorialCallback? onSkip;

  /// Step change callback
  StepCallback? onStepChanged;

  /// Step show callback
  StepCallback? onStepShow;

  /// Step hide callback
  StepCallback? onStepHide;

  TutorialController({
    TutorialConfig? config,
    this.onComplete,
    this.onSkip,
    this.onStepChanged,
    this.onStepShow,
    this.onStepHide,
  }) : _config = config ?? const TutorialConfig();

  /// Gets the current configuration
  TutorialConfig get config => _config;

  /// Gets all tutorial steps
  List<TutorialStep> get steps => List.unmodifiable(_steps);

  /// Gets the current step index
  int get currentStepIndex => _currentStepIndex;

  /// Gets the current step
  TutorialStep? get currentStep => _isActive && _currentStepIndex < _steps.length 
      ? _steps[_currentStepIndex] 
      : null;

  /// Gets the total number of steps
  int get totalSteps => _steps.length;

  /// Whether the tutorial is currently active
  bool get isActive => _isActive;

  /// Whether the tutorial is paused
  bool get isPaused => _isPaused;

  /// Whether there is a next step
  bool get hasNextStep => _currentStepIndex < _steps.length - 1;

  /// Whether there is a previous step
  bool get hasPreviousStep => _currentStepIndex > 0;

  /// Whether this is the first step
  bool get isFirstStep => _currentStepIndex == 0;

  /// Whether this is the last step
  bool get isLastStep => _currentStepIndex == _steps.length - 1;

  /// Adds a step to the tutorial
  void addStep(TutorialStep step) {
    _steps.add(step);
    notifyListeners();
  }

  /// Adds multiple steps to the tutorial
  void addSteps(List<TutorialStep> steps) {
    _steps.addAll(steps);
    notifyListeners();
  }

  /// Inserts a step at a specific index
  void insertStep(int index, TutorialStep step) {
    if (index >= 0 && index <= _steps.length) {
      _steps.insert(index, step);
      if (_isActive && index <= _currentStepIndex) {
        _currentStepIndex++;
      }
      notifyListeners();
    }
  }

  /// Removes a step at a specific index
  void removeStep(int index) {
    if (index >= 0 && index < _steps.length) {
      _steps.removeAt(index);
      if (_isActive) {
        if (index < _currentStepIndex) {
          _currentStepIndex--;
        } else if (index == _currentStepIndex && _currentStepIndex >= _steps.length) {
          _currentStepIndex = _steps.length - 1;
        }
      }
      notifyListeners();
    }
  }

  /// Updates a step at a specific index
  void updateStep(int index, TutorialStep step) {
    if (index >= 0 && index < _steps.length) {
      _steps[index] = step;
      notifyListeners();
    }
  }

  /// Clears all steps
  void clearSteps() {
    _steps.clear();
    if (_isActive) {
      stop();
    }
    notifyListeners();
  }

  /// Starts the tutorial
  Future<void> start({int? startIndex}) async {
    if (_steps.isEmpty) return;

    _currentStepIndex = startIndex ?? 0;
    _isActive = true;
    _isPaused = false;

    // Clamp the index to valid range
    _currentStepIndex = _currentStepIndex.clamp(0, _steps.length - 1);

    onStepShow?.call(_currentStepIndex);
    currentStep?.onShow?.call();

    _startAutoPlayTimer();
    notifyListeners();
  }

  /// Stops the tutorial
  void stop() {
    if (!_isActive) return;

    _stopAutoPlayTimer();
    
    currentStep?.onHide?.call();
    onStepHide?.call(_currentStepIndex);

    _isActive = false;
    _isPaused = false;
    _currentStepIndex = 0;
    
    notifyListeners();
  }

  /// Pauses the tutorial
  void pause() {
    if (!_isActive || _isPaused) return;

    _isPaused = true;
    _stopAutoPlayTimer();
    notifyListeners();
  }

  /// Resumes the tutorial
  void resume() {
    if (!_isActive || !_isPaused) return;

    _isPaused = false;
    _startAutoPlayTimer();
    notifyListeners();
  }

  /// Goes to the next step
  Future<void> next() async {
    if (!_isActive || !hasNextStep) return;

    final currentStepObj = currentStep;
    
    // Check if current step allows progression
    if (currentStepObj?.waitForUserAction == true && 
        currentStepObj?.canProceed?.call() == false) {
      return;
    }

    await _changeStep(_currentStepIndex + 1);
  }

  /// Goes to the previous step
  Future<void> previous() async {
    if (!_isActive || !hasPreviousStep) return;
    await _changeStep(_currentStepIndex - 1);
  }

  /// Goes to a specific step
  Future<void> goToStep(int index) async {
    if (!_isActive || index < 0 || index >= _steps.length || index == _currentStepIndex) {
      return;
    }
    await _changeStep(index);
  }

  /// Skips the tutorial
  void skip() {
    if (!_isActive) return;

    _stopAutoPlayTimer();
    
    currentStep?.onHide?.call();
    onStepHide?.call(_currentStepIndex);

    _isActive = false;
    _isPaused = false;
    
    onSkip?.call();
    notifyListeners();
  }

  /// Completes the tutorial
  void complete() {
    if (!_isActive) return;

    _stopAutoPlayTimer();
    
    currentStep?.onHide?.call();
    onStepHide?.call(_currentStepIndex);

    _isActive = false;
    _isPaused = false;
    
    onComplete?.call();
    notifyListeners();
  }

  /// Forces the current step to allow progression (for waitForUserAction steps)
  void allowProgression() {
    if (currentStep?.waitForUserAction == true) {
      notifyListeners();
    }
  }

  /// Changes to a specific step
  Future<void> _changeStep(int newIndex) async {
    final oldIndex = _currentStepIndex;
    final oldStep = currentStep;

    // Hide current step
    oldStep?.onHide?.call();
    onStepHide?.call(oldIndex);

    _currentStepIndex = newIndex;

    // Show new step
    currentStep?.onShow?.call();
    onStepShow?.call(_currentStepIndex);
    onStepChanged?.call(_currentStepIndex);

    _restartAutoPlayTimer();
    notifyListeners();
  }

  /// Starts the auto-play timer
  void _startAutoPlayTimer() {
    if (_config.autoPlayDelay != null && !_isPaused) {
      _autoPlayTimer = Timer(_config.autoPlayDelay!, () {
        if (hasNextStep) {
          next();
        } else {
          complete();
        }
      });
    }
  }

  /// Stops the auto-play timer
  void _stopAutoPlayTimer() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  /// Restarts the auto-play timer
  void _restartAutoPlayTimer() {
    _stopAutoPlayTimer();
    _startAutoPlayTimer();
  }

  @override
  void dispose() {
    _stopAutoPlayTimer();
    super.dispose();
  }
}