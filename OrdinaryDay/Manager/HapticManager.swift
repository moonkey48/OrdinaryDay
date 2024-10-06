//
//  HapticManager.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/6/24.
//

import CoreHaptics
import Foundation

protocol HapticManager {
    func startHaptic(intensity: Float, sharpness: Float) -> Void
    func stop() -> Void
}

extension HapticManagerImpl {
    static let defaultIntensity: Float = 0.46
    static let defaultSharpness: Float = 0.23
}

final class HapticManagerImpl: HapticManager {

    private let engine: CHHapticEngine
    private var player: CHHapticPatternPlayer?

    init?() {
        do {
            let capablitity = CHHapticEngine.capabilitiesForHardware()

            if capablitity.supportsHaptics {
                let engine = try CHHapticEngine()
                self.engine = engine
                try engine.start()
                print("haptic manager return.")
            } else {
                print("haptic manager nil.")
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }

    deinit {
        stop()
        engine.stop()
    }

    func startHaptic(intensity: Float = 1, sharpness: Float = 1) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        var events = [CHHapticEvent]()

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let eventSecond = CHHapticEvent(eventType: .hapticTransient, parameters: [
            intensity,
            sharpness,
        ], relativeTime: 0.1)
        events.append(eventSecond)

        startEvents(events)
    }

    private func startEvents(_ events: [CHHapticEvent]) {
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            player = try engine.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            print("haptic success")
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

    func stop() {
        try? player?.stop(atTime: 0)
    }
}
