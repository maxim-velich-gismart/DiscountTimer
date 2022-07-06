//
//  TimerView.swift
//  Discount Timer
//
//  Created by Maksim Velich on 4.07.22.
//

import UIKit

final class TimerView: UIView {
    
    @IBOutlet private weak var secondView: UIView!
    @IBOutlet private weak var topSecondLabel: UILabel!
    @IBOutlet private weak var secondLabel: UILabel!
    @IBOutlet private weak var minuteView: UIView!
    @IBOutlet private weak var minuteLabel: UILabel!
    @IBOutlet private weak var topMinuteLabel: UILabel!
    @IBOutlet private weak var hourView: UIView!
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var topHourLabel: UILabel!
    @IBOutlet private weak var topSecondsView: UIView!
    @IBOutlet private weak var topMinuteView: UIView!
    @IBOutlet private weak var topHourView: UIView!
    
    private let secondOpaqueLayer = CALayer()
    private let minuteOpaqueLayer = CALayer()
    private let hourOpaqueLayer = CALayer()
    
    private weak var timer: Timer?
    private(set) var timerDuration: Int = 82810 // test hours - 82810 86400
    private(set) var timeConfiguration = (hours: 0, minutes: 0, seconds: 60)
    
    private var distanceBeetwenCenters: CGFloat {
        return (topSecondLabel.bounds.height / 2) + (secondLabel.bounds.height / 2) + secondLabel.frame.origin.y
    }
    
    private var animateMinuteLabel: Bool {
        return timeConfiguration.seconds == 59 && timerDuration > 0
    }
    
    private var animateHourLabel: Bool {
        return timeConfiguration.minutes == 59 &&
               timeConfiguration.seconds == 59 &&
               (timerDuration / 3600) >= 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        addOpaqueLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
        addOpaqueLayers()
    }
    
    deinit {
        resetTimer()
    }
}

// MARK: - External functions
extension TimerView {
    func updateOpaqueLayersFrames() {
        secondOpaqueLayer.frame = topSecondsView.frame
        minuteOpaqueLayer.frame = topMinuteView.frame
        hourOpaqueLayer.frame = topHourView.frame
    }
    
    func startTimer() {
        setupInitialTimerValues(for: timerDuration)
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    @objc private func updateTimer() {
        if timerDuration > 0 {
            timerDuration -= 1
            timeConfiguration = TimeConversion.secondsToHoursMinutesSeconds(for: timerDuration)
            setupUnfoldingTimerValues()
            runTimerAnimation()
        } else {
            resetTimer()
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}

//MARK: - UI
private extension TimerView {
    func commonInit() {
        guard let viewFromXib = Bundle.main.loadNibNamed("TimerView", owner: self, options: nil)?[0] as? UIView else {
            return
        }
        
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }
    
    func setupInitialTimerValues(for interval: Int) {
        timeConfiguration = TimeConversion.secondsToHoursMinutesSeconds(for: interval)
        
        setupFoldingTimerValues()
        setupUnfoldingTimerValues()
    }
    
    func addOpaqueLayers() {
        secondOpaqueLayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        minuteOpaqueLayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        hourOpaqueLayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.addSublayer(secondOpaqueLayer)
        layer.addSublayer(minuteOpaqueLayer)
        layer.addSublayer(hourOpaqueLayer)
    }
    
    func setupFoldingTimerValues() {
        secondLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.seconds)
        minuteLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.minutes)
        hourLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.hours)
    }
    
    func setupUnfoldingTimerValues() {
        topSecondLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.seconds)
        topMinuteLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.minutes)
        topHourLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.hours)
    }
}

//MARK: - Animation
private extension TimerView {
    func runTimerAnimation() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
            self.preparatoryAnimation() // Responsible for animating moving objects to the starting point for the main animation in the desired form
        }, completion: { _ in
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           options: .curveLinear,
                           animations: {
                self.mainAnimation()
            }, completion: { _ in
                self.resetAnimation()
            })
        })
    }
    
    func preparatoryAnimation() {
        var preparatoryTransform = CATransform3DIdentity
        preparatoryTransform = CATransform3DTranslate(preparatoryTransform, 0.0, distanceBeetwenCenters / 2, 0.0)
        preparatoryTransform = CATransform3DScale(preparatoryTransform, 0.95, 0.6, 0.6)
        preparatoryTransform = CATransform3DRotate(preparatoryTransform, .pi/4, 1.0, 0.0, 0.0)
        
        topSecondLabel.layer.transform = preparatoryTransform
        
        if animateMinuteLabel {
            topMinuteLabel.layer.transform = preparatoryTransform
        }
        
        if animateHourLabel {
            topHourLabel.layer.transform = preparatoryTransform
        }
    }
    
    func mainAnimation() {
        var foldingTransform = CATransform3DIdentity
        foldingTransform = CATransform3DTranslate(foldingTransform, 0.0, distanceBeetwenCenters / 2, 0.0)
        foldingTransform = CATransform3DScale(foldingTransform, 0.95, 0.6, 1.0)
        foldingTransform = CATransform3DRotate(foldingTransform, .pi/4, -1.0, 0.0, 0.0)
        
        var unfoldingTransform = CATransform3DIdentity
        unfoldingTransform = CATransform3DTranslate(unfoldingTransform, 0.0, distanceBeetwenCenters, 0.0)
        unfoldingTransform = CATransform3DScale(unfoldingTransform, 1, 1, 1)
        unfoldingTransform = CATransform3DRotate(unfoldingTransform, .pi/4, 0.0, 0.0, 0.0)
        
        secondLabel.layer.transform = foldingTransform
        secondLabel.alpha = 0
        topSecondLabel.layer.transform = unfoldingTransform
        topSecondLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        topSecondLabel.alpha = 1
        
        if animateMinuteLabel {
            minuteLabel.layer.transform = foldingTransform
            minuteLabel.alpha = 0
            topMinuteLabel.layer.transform = unfoldingTransform
            topMinuteLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            topMinuteLabel.alpha = 1
        }
        
        if animateHourLabel {
            hourLabel.layer.transform = foldingTransform
            hourLabel.alpha = 0
            topHourLabel.layer.transform = unfoldingTransform
            topHourLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            topHourLabel.alpha = 1
        }
    }
    
    func resetAnimation() {
        secondLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.seconds)
        minuteLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.minutes)
        hourLabel.text = TimeConversion.timeToStringLiteral(for: timeConfiguration.hours)
        
        [secondLabel, minuteLabel, hourLabel].forEach {
            $0?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            $0?.alpha = 1
            $0?.layer.removeAllAnimations()
            $0?.layer.transform = CATransform3DIdentity
        }
        
        [topSecondLabel, topMinuteLabel, topHourLabel].forEach {
            $0?.textColor = #colorLiteral(red: 0.5667635202, green: 0.5667635202, blue: 0.5667635202, alpha: 1)
            $0?.alpha = 0
            $0?.layer.removeAllAnimations()
            $0?.layer.transform = CATransform3DIdentity
        }
    }
}
