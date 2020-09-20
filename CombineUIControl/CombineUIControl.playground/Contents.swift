import UIKit
import Combine
import PlaygroundSupport

extension UIControl {
    struct EventPublisher: Combine.Publisher {
        typealias Output = UIControl
        typealias Failure = Never

        let control: UIControl
        let event: UIControl.Event

        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = EventSubscription(control: control, event: event, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }

    private final class EventSubscription<S: Subscriber>: Subscription where S.Input == UIControl, S.Failure == Never {

        private let control: UIControl
        private let event: UIControl.Event
        private var subscriber: S?
        private var openDemand: Subscribers.Demand = .unlimited
        private var events: Int = 0
        private let lock = NSRecursiveLock()

        init(control: UIControl, event: UIControl.Event, subscriber: S) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            control.addTarget(self, action: #selector(didReceiveEvent), for: event)
        }

        func request(_ demand: Subscribers.Demand) {
            guard let subscriber = subscriber else { return }
            lock.lock()
            openDemand += demand
            while openDemand.max ?? 1 > 0 && events > 0 {
                openDemand += subscriber.receive(control)
                openDemand -= 1
                events -= 1
            }
            lock.unlock()
        }

        func cancel() {
            subscriber = nil
        }

        @objc private func didReceiveEvent() {
            guard let subscriber = subscriber else { return }
            lock.lock()
            events += 1
            if openDemand.max ?? 1 > 0 {
                subscriber.receive(control)
                openDemand -= 1
                events -= 1
            }
            lock.unlock()
        }
    }
}

let button = UIButton(type: .system)
button.frame = CGRect(x: 0, y: 0, width: 128, height: 32)
button.setTitle("Tap me!", for: .normal)

var subscriptions = Set<AnyCancellable>()
UIControl.EventPublisher(control: button, event: .touchUpInside)
    .print()
    .sink(receiveValue: { _ in print("touchUpInside") })
    .store(in: &subscriptions)

PlaygroundPage.current.liveView = button
PlaygroundPage.current.needsIndefiniteExecution = true


