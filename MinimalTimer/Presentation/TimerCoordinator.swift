import UIKit

protocol TimerCoordinatorFlowCoordinatorDependencies {
    func  makeTimerViewController(actions: TimerViewModelActions) -> UIViewController
}

class TimerCoordinator {
    weak var navigationController: UINavigationController?
    let dependencies: TimerCoordinatorFlowCoordinatorDependencies
    
    
    init(navigationController: UINavigationController, dependencies: TimerCoordinatorFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = TimerViewModelActions(showAlert: showAlert)
        let vc = dependencies.makeTimerViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "alert", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        navigationController?.topViewController?.present(alertController, animated: true)
    }
}
