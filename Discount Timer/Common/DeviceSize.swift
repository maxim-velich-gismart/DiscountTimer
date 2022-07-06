//
//  DeviceSize.swift
//  Discount Timer
//
//  Created by Maksim Velich on 4.07.22.
//

import UIKit

/**
 Simple solution to handle current task.
 Can be extented and be written in other way if needed to cover many screens and logical idioms.
 Omit the possibility of screen rotation since the application is displayed in landscape mode only.
 */

struct DeviceSize {
    enum ScreenSize {
        case small
        case regular
        case large
    }
    
    private let screenHeight = UIScreen.main.bounds.height
    
    var type: ScreenSize {
        if screenHeight < 390 {
            return .small
        } else if screenHeight == 390 {
            return .regular
        } else {
            return .large
        }
    }
}
