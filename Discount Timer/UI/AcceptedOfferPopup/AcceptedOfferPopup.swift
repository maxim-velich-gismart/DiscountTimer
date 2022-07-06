//
//  AcceptedOfferPopup.swift
//  Discount Timer
//
//  Created by Maksim Velich on 6.07.22.
//

import SnapKit

final class AcceptedOfferPopup: UIView {
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var congratsLabel: UILabel = {
        let label = UILabel()
        label.text = "Great!"
        label.font =  .systemFont(ofSize: 25, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupTheme()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    func configure(with text: String) {
        timeLabel.text = "Offer activated at \(text)"
    }
}

private extension AcceptedOfferPopup {
    func setupConstraints() {
        addSubview(congratsLabel)
        congratsLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(30)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(30)
        }
    }
    
    func setupTheme() {
        backgroundColor = #colorLiteral(red: 0.02352941176, green: 0, blue: 0.3176470588, alpha: 1)
        layer.cornerRadius = 12
        congratsLabel.layer.shadowColor = #colorLiteral(red: 0.01568627451, green: 0.2823529412, blue: 0.7333333333, alpha: 1)
        congratsLabel.layer.shadowOffset = .init(width: 1, height: 1)
        congratsLabel.layer.shadowRadius = 6.0
        congratsLabel.layer.shadowOpacity = 1.0
    }
}
