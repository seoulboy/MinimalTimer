import UIKit

final class TimerDIContainer: TimerCoordinatorFlowCoordinatorDependencies {
    func makeTimerRepository() -> TimerRepositoryType {
        TimerRepository()
    }
    
    func makeTimerUseCase() -> TimerUseCaseType {
        TimerUseCase(repository: makeTimerRepository())
    }
    
    func makeTimerViewModel(actions: TimerViewModelActions) -> TimerViewModel {
        TimerViewModel(actions: actions, useCase: makeTimerUseCase())
    }
    
    func makeTimerViewController(actions: TimerViewModelActions) -> UIViewController {
        let vc = TimerViewController(viewModel: makeTimerViewModel(actions: actions))
        return vc
    }
    
    func makeTimerCoordinator(navigationController: UINavigationController) -> TimerCoordinator {
        TimerCoordinator(navigationController: navigationController, dependencies: self)
    }
}
