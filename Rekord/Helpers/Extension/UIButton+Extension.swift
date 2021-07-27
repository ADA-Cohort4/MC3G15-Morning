//
//  UIButton+Extension.swift
//  Kantongku
//
//  Created by Julius Cesario on 04/05/21.
//

import UIKit

struct UIButtonViewModel {
    let primaryText: String
}

final class UIButton_Extension: UIButton {
    
    private let primaryLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        addSubview(primaryLabel)
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel:UIButtonViewModel){
        primaryLabel.text = viewModel.primaryText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        primaryLabel.frame = CGRect(x:0, y:0, width:frame.size.width, height: frame.size.height)
    }

}
