//
//  SecurityTimer.swift
//  Catalog
//
//  Created by Jasmin Abou Aldan on 07.05.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//
// Implemented from: https://medium.com/over-engineering/a-background-repeating-timer-in-swift-412cecfd2ef9

import Foundation

/// RepeatingTimer mimics the API of DispatchSourceTimer but in a way that prevents
/// crashes that occur from calling resume multiple times on a timer that is
/// already resumed (noted by https://github.com/SiftScience/sift-ios/issues/52
class SecurityTimer {

    // MARK: - Public properties
    
    let timeInterval: TimeInterval
    var eventHandler: (() -> Void)?
    
    // MARK: - Private properties

    private lazy var timer: DispatchSourceTimer = {
        let timerSource = DispatchSource.makeTimerSource()
        timerSource.schedule(deadline: .now() + timeInterval, repeating: timeInterval)
        timerSource.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return timerSource
    }()

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    // MARK: - Lifecycle

    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
        */
        resume()
        eventHandler = nil
    }
    
    // MARK: - Public methods

    func resume() {
        switch state {
        case .resumed: break
        case .suspended:
            state = .resumed
            timer.resume()
        }
    }

    func suspend() {
        switch state {
        case .resumed:
            state = .resumed
            timer.resume()
        case .suspended: break
        }
    }
    
}
