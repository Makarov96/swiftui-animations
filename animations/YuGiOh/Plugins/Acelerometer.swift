//
//  Acelerometer.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 25/05/24.
//

import Foundation
import CoreMotion



typealias Execute = (_ x:Double,_ y:Double,_ z:Double)->Void

class GyroscopeManager: ObservableObject {
    private var motionManager: CMMotionManager
    private var timer: Timer?
    
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0

    // Smooth values
    @Published var smoothedPitch: Double = 0.0
    @Published var smoothedRoll: Double = 0.0
    @Published var smoothedYaw: Double = 0.0

    private let smoothingFactor = 0.1

    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.deviceMotionUpdateInterval = 1 / 60.0
        self.motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
            guard let motion = motion, error == nil else { return }
           
            self.pitch =  motion.gravity.x
            self.roll = motion.gravity.y
            self.yaw = motion.gravity.z

            self.applySmoothing()
        }
    }

    private func applySmoothing() {
        self.smoothedPitch = self.smoothedPitch + (self.pitch - self.smoothedPitch) * smoothingFactor
        self.smoothedRoll = self.smoothedRoll + (self.roll - self.smoothedRoll) * smoothingFactor
        self.smoothedYaw = self.smoothedYaw + (self.yaw - self.smoothedYaw) * smoothingFactor
    }
}
