//
//  JQActionSheetCell.swift
//  
//
//  Created by HJQ on 2017/6/23.
//  Copyright © 2017年 HJQ. All rights reserved.
//

import UIKit

public class JQActionSheetCell: UITableViewCell {
    
    
    public lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel.init()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - private method
    private func setupUI() {
        contentView.addSubview(titleLabel)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = self.bounds
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
