struct TimerViewModelActions {
    let showAlert: () -> Void
}

protocol TimerViewModelInput {
    func showAlert()
}
protocol TimerViewModelOutput {}

typealias TimerViewModelType = TimerViewModelInput & TimerViewModelOutput

final class TimerViewModel: TimerViewModelType {
    
    let actions: TimerViewModelActions
    let useCase: TimerUseCaseType
    
    init(actions: TimerViewModelActions, useCase: TimerUseCaseType) {
        self.actions = actions
        self.useCase = useCase
    }
    
    func showAlert() {
        actions.showAlert()
    }
}
