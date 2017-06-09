//
//  MarkerView.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 09.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import UIKit


class MarkerView: UIView
{
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(1000, for: UILayoutConstraintAxis.vertical)
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    func layoutViews() {
        
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(ratingLabel)
        
        let stackView = UIStackView(arrangedSubviews: [ titleLabel,
                                                        descriptionLabel,
                                                        ratingLabel])
        
        self.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        
        stackView.anchor(topAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         topConstant: 4,
                         leftConstant: 4,
                         bottomConstant: 4,
                         rightConstant: 4,
                         widthConstant: 0,
                         heightConstant: 0)
    }
    
}
