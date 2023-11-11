protocol TimerUseCaseType {}

class TimerUseCase: TimerUseCaseType {
    let repository: TimerRepositoryType
    
    init(repository: TimerRepositoryType) {
        self.repository = repository
    }
}
