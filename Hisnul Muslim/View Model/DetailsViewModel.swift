//
//  DetailsViewModel.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 6/30/24.
//

import Foundation
import Combine

class DetailsViewModel {
    let event = PassthroughSubject<Event, Never>()
    @Published var state: State
    private var cancellables = Set<AnyCancellable>()
    
    init(content: Content) {
        self.state = State(details: content)
        event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &cancellables)
    }
    
    private func handleEvent(_ event: Event) {
        switch event {
        case .addFavorite(let content):
            addFavorite(content)
        case .notify:
            checkNotificationAccess()
        default:
            break
        }
    }
    
    func addFavorite(_ content: Content) {
        let favorite = Content(id: content.id, title: content.title, pages: content.pages)
        
        Task {
            do {
                try await PersistenceManager.updateWith(favorite: favorite, actionType: .add)
                event.send(.showMessage("نجاح", "تمت الإضافة إلى المفضلة.", .ok))
            } catch {
                event.send(.showMessage("خطأ", "فشل في الإضافة إلى المفضلة.", .ok))
            }
        }
    }
    
    func checkNotificationAccess() {
        Task {
            let isAllowed = await SchedulerNotifications.shared.isUserAllowNotification
            if isAllowed {
                event.send(.didNotify(state.details))
            } else {
                event.send(.showMessage("خطأ", "يجب أن تسمح بالإشعارات في الإعدادات.", .okWithSettings))
            }
        }
    }

}

extension DetailsViewModel {
    enum Event {
        case addFavorite(Content)
        case notify, didNotify(Content)
        case showMessage(String, String, AlertVC.AlertAction)
    }
    
    struct State {
        var details: Content
    }
}
