/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

public enum CountdownTimerState {
    case stopped
    case paused(atDate: Date)
    case inProgress
}

public protocol CountdownTimerProtocol: class {
    var delegate: CountdownTimerDelegate? { get set }
    var state: CountdownTimerState { get }
    var notificationInterval: TimeInterval { get }
    var remainedInterval: TimeInterval { get }

    func start(with interval: TimeInterval)
    func stop()
}

public protocol CountdownTimerDelegate: class {
    func didStart(with interval: TimeInterval)
    func didCountdown(remainedInterval: TimeInterval)
    func didStop(with remainedInterval: TimeInterval)
}

public final class CountdownTimer: NSObject {

    public weak var delegate: CountdownTimerDelegate?

    private var applicationHandler: ApplicationHandlerProtocol
    private var timer: Timer?

    public private(set) var state: CountdownTimerState = .stopped
    public private(set) var remainedInterval: TimeInterval = 0.0
    public private(set) var lastNotifiedInterval: TimeInterval = 0.0
    public let notificationInterval: TimeInterval

    public init(delegate: CountdownTimerDelegate,
         applicationHander: ApplicationHandlerProtocol = ApplicationHandler(),
         notificationInterval: TimeInterval = 1.0) {
        self.delegate = delegate
        self.applicationHandler = applicationHander
        self.notificationInterval = notificationInterval

        super.init()
    }

    @objc private func actionTimer(_ sender: Timer) {
        remainedInterval -= sender.timeInterval

        if remainedInterval < TimeInterval.leastNonzeroMagnitude {
            remainedInterval = 0.0
            lastNotifiedInterval = 0.0

            stop()
        } else if lastNotifiedInterval - remainedInterval >= notificationInterval {
            lastNotifiedInterval = remainedInterval
            delegate?.didCountdown(remainedInterval: remainedInterval)
        }
    }

    private func scheduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(actionTimer(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
}

extension CountdownTimer: CountdownTimerProtocol {
    public func start(with interval: TimeInterval) {
        stop()

        remainedInterval = interval
        lastNotifiedInterval = interval

        state = .inProgress

        delegate?.didStart(with: remainedInterval)

        if remainedInterval > 0 {
            applicationHandler.delegate = self

            scheduleTimer()
        } else {
            state = .stopped

            delegate?.didStop(with: remainedInterval)
        }
    }

    public func stop() {
        let previousState = state

        state = .stopped

        timer?.invalidate()
        timer = nil

        let currentRemainedInterval = remainedInterval
        remainedInterval = 0.0
        lastNotifiedInterval = 0.0

        applicationHandler.delegate = nil

        switch previousState {
        case .inProgress, .paused:
            delegate?.didStop(with: currentRemainedInterval)
        default:
            break
        }
    }
}

extension CountdownTimer: ApplicationHandlerDelegate {
    public func didReceiveWillResignActive(notification: Notification) {
        if case .inProgress = state {
            state = .paused(atDate: Date())

            timer?.invalidate()
            timer = nil
        }
    }

    public func didReceiveDidBecomeActive(notification: Notification) {
        if case .paused(let date) = state {
            let leftInterval = Date().timeIntervalSince(date)

            guard leftInterval >= 0 else {
                stop()
                return
            }

            if remainedInterval - leftInterval > 0.0 {
                remainedInterval -= leftInterval
                state = .inProgress

                scheduleTimer()

                if lastNotifiedInterval - remainedInterval >= notificationInterval {
                    lastNotifiedInterval = remainedInterval
                    delegate?.didCountdown(remainedInterval: remainedInterval)
                }

            } else {
                stop()
            }
        }
    }
}
