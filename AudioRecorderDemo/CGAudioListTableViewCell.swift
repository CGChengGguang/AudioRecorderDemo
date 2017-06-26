//
//  CGAudioListTableViewCell.swift
//  AudioRecorderDemo
//
//  Created by chenguang on 2017/6/25.
//  Copyright © 2017年 chenguang. All rights reserved.
//

import UIKit

class CGAudioListTableViewCell: UITableViewCell {

    let playingFlagBtn = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.setupUI();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {

        self.contentView.addSubview(playingFlagBtn);
        self.playingFlagBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.right.equalToSuperview().inset(20.0);
        }
        
        self.playingFlagBtn.setImage(UIImage.init(named: "icon_play_flag"), for: UIControlState.normal);
        self.playingFlagBtn.setImage(UIImage.init(named: "icon_pause_flag"), for: UIControlState.selected);
        self.playingFlagBtn.isSelected = false;
    }
    
    func bindData(_ cellData:CGAudioListTableCellData) {
        self.textLabel?.text = cellData.audioName;
        self.playingFlagBtn.isSelected = cellData.isPlaying;
    }
    
}
