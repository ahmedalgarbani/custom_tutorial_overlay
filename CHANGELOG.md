# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-09-4

### Added
- Initial release of custom_tutorial_overlay package
- **Core Features:**
  - Fully customizable tutorial overlay with spotlight effects
  - Support for circle, rounded rectangle, and rectangle spotlight shapes
  - Blur and dim background effects
  - Step-by-step navigation with "Next", "Previous", and "Skip" buttons
  
- **Widget Targeting:**
  - Target widgets using GlobalKeys for precise highlighting
  - Custom positioning and sizing for non-widget targets
  - Automatic spotlight positioning with padding control
  
- **UI Customization:**
  - Customizable tooltip content, colors, and positioning
  - Custom navigation buttons and step indicators
  - Theme adaptation for light/dark mode
  - Animated transitions between steps
  
- **Step Indicators:**
  - Built-in styles: dots, progress bar, and numbers
  - Custom step indicator widget builder support
  - Configurable positioning (top, bottom, corners)
  
- **Advanced Features:**
  - Async step progression with user action waiting
  - Custom validation for step progression
  - Auto-play functionality with configurable delays
  - Swipe gestures for navigation (optional)
  - Barrier dismissible configuration
  
- **API Design:**
  - Declarative approach with `TutorialBuilder` widget
  - Imperative approach with `TutorialController`
  - Context extensions for easy tutorial control
  - Comprehensive configuration options
  
- **Developer Experience:**
  - Full null safety support
  - Comprehensive documentation and examples
  - Extensive test coverage
  - Flutter best practices implementation
  - Cross-platform support (mobile and web)
  
- **Components:**
  - `TutorialController` - Main controller for tutorial management
  - `TutorialOverlay` - Core overlay widget
  - `TutorialBuilder` - Declarative wrapper widget
  - `TutorialStep` - Individual step configuration
  - `TutorialConfig` - Global configuration options
  - `StepIndicatorWidget` - Built-in step indicators
  - `TutorialScope` - Inherited widget for context access
  
### Documentation
- Complete API documentation
- Usage examples (imperative and declarative)
- Advanced feature guides
- Integration examples
- Testing documentation

### Testing
- Unit tests for all controllers and models
- Widget tests for UI components
- Integration tests for complete workflows
- Test coverage for edge cases and error scenarios