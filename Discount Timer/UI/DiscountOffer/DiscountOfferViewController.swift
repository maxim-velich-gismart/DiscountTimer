//
//  DiscountOfferViewController.swift
//  Discount Timer
//
//  Created by Maksim Velich on 3.06.22.
//

import UIKit

final class DiscountOfferViewController: UIViewController {
    
    @IBOutlet private weak var chanceInfoLabel: UILabel!
    @IBOutlet private weak var discountInfoLabel: UILabel!
    @IBOutlet private weak var musicInfoLabel: UILabel!
    @IBOutlet private weak var songsInfoLabel: UILabel!
    @IBOutlet private weak var activateOfferButton: UIButton!
    @IBOutlet private weak var activateOfferButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var activateOfferButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timerView: TimerView!
    
    private lazy var acceptedOfferPopup = AcceptedOfferPopup(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addStateObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applyButtonGradient()
        applyButtonShadow()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        timerView.updateOpaqueLayersFrames()
    }
    
    @IBAction func activateOfferButtonTapped(_ sender: Any) {
        timerView.resetTimer()
        addDimmedView()
        showAcceptedOfferPopup()
    }
}

private extension DiscountOfferViewController {
    func setupUI() {
        chanceInfoLabel.text = "LAST-MINUTE CHANCE! \n to claim your offer"
        
        switch DeviceSize().type {
        case .small:
            chanceInfoLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            discountInfoLabel.font = .systemFont(ofSize: 30, weight: .black)
            musicInfoLabel.font = .systemFont(ofSize: 12, weight: .semibold)
            songsInfoLabel.font = .systemFont(ofSize: 12, weight: .regular)
            activateOfferButtonHeightConstraint.constant = 50
            activateOfferButtonWidthConstraint.constant = 250
        case .regular:
            chanceInfoLabel.font = .systemFont(ofSize: 18, weight: .semibold)
            discountInfoLabel.font = .systemFont(ofSize: 40, weight: .black)
        case .large:
            return // Handles by storyboard layout calculation
        }
    }
    
    func applyButtonGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = activateOfferButton.bounds
        gradient.colors = [#colorLiteral(red: 0.2549019608, green: 0.2705882353, blue: 0.5960784314, alpha: 1) , #colorLiteral(red: 0.9176470588, green: 0.2823529412, blue: 0.7333333333, alpha: 1)].map { $0.cgColor }
        gradient.startPoint = .init(x: 0.0, y: 0.0)
        gradient.endPoint = .init(x: 0.0, y: 1.0)
        gradient.cornerRadius = 12
        gradient.name = "buttonGradient"
        activateOfferButton.layer.sublayers?.filter { $0.name == gradient.name }.first?.removeFromSuperlayer()
        activateOfferButton.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyButtonShadow() {
        activateOfferButton.layer.shadowColor = #colorLiteral(red: 0.9176470588, green: 0.2823529412, blue: 0.7333333333, alpha: 1)
        activateOfferButton.layer.shadowPath = UIBezierPath(roundedRect: activateOfferButton.bounds,
                                                            cornerRadius: 12).cgPath
        activateOfferButton.layer.shadowOffset = .init(width: 0.0, height: 1.0)
        activateOfferButton.layer.shadowOpacity = 0.8
        activateOfferButton.layer.shadowRadius = 20
    }
    
    func addDimmedView() {
        let dimmedView = UIView()
        dimmedView.backgroundColor = .black
        dimmedView.alpha = 0.4
        view.addSubview(dimmedView)
        dimmedView.frame = view.bounds
    }
    
    func showAcceptedOfferPopup() {
        view.addSubview(acceptedOfferPopup)
        acceptedOfferPopup.snp.makeConstraints { make in
            make.height.equalTo(130)
            make.width.equalTo(280)
            make.centerX.centerY.equalToSuperview()
        }
        let acceptedTime = TimeConversion.timeToStringLiteral(hours: timerView.timeConfiguration.hours,
                                                                   minutes: timerView.timeConfiguration.minutes,
                                                                   seconds: timerView.timeConfiguration.seconds)
        acceptedOfferPopup.configure(with: acceptedTime)
    }
    
    func addStateObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(processAppBackgroundState),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(processAppForegroundState),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc func processAppBackgroundState() {
        timerView.resetTimer()
    }
    
    @objc func processAppForegroundState() {
        setupUI()
        timerView.startTimer()
    }
}
