//
//  ViewController.swift
//  AudioRecorderDemo
//
//  Created by chenguang on 2017/6/25.
//  Copyright © 2017年 chenguang. All rights reserved.
//

import UIKit
import SnapKit

class CGMainViewController: UIViewController {
    
    fileprivate var recorderBtn: UIButton = UIButton()
    fileprivate var completeBtn: UIButton = UIButton()
    fileprivate var playBtn: UIButton = UIButton()
    fileprivate var btnsContainer: UIView = UIView()
    fileprivate lazy var recorder: CGAudioHandler = CGAudioHandler()
    fileprivate lazy var audioManager: CGAudioDataManager = CGAudioDataManager.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI();
    }
    
    // UI
    func setupUI() {
        
        self.addSubviews();
        self.addSubviewConstraints();
        self.setupSubviews();
    }
    
    // action
    func recorderBtnTouchedDown(_ sender:UIButton) {
        
        recorder.startRecord();
    }
    
    func recorderBtnTouchedUp(_ sender:UIButton) {
        
        // 抬起手指 录音结束
        recorder.stopRecord();
        playBtn.isEnabled = true;
        completeBtn.isEnabled = true;
    }
    
    func recorderBtnTouchCanceled(_ sender:UIButton) {
        
        // 滑开手指  取消录音
        recorder.cancelRecord();
        playBtn.isEnabled = false;
        completeBtn.isEnabled = false;
    }
    
    func playBtnClicked(_ sender:UIButton) {
        
        recorder.startPlaying();
    }
    
    func completeBtnClicked(_ sender:UIButton) {
        
        // 点击完成  保存
        let url = recorder.currentAudioURL;
        let recordData = NSData.init(contentsOf: url!);
        let alert = UIAlertController(title: "存储新录音", message: nil, preferredStyle: UIAlertControllerStyle.alert);
        alert.addTextField { (textField) in
            textField.text = "新录音";
        };
        
        let saveAction = UIAlertAction.init(title: "完成", style: UIAlertActionStyle.default) { (_) in
            let field = alert.textFields![0];
            if ((field.text?.characters.count)! > 0) {
                self.audioManager.addOneAudio(recordData!, field.text!);
            }
        };
        
        alert.addAction(saveAction);
        self.present(alert, animated: true, completion: nil);
    }
    
    func rightBarItemClicked() {
        
        let vc = CGAudioListViewController();
        self.navigationController?.pushViewController(vc, animated: true);
    }
}

extension CGMainViewController {
    
    func addSubviews() {
        
        view.addSubview(btnsContainer);
        btnsContainer.addSubview(playBtn);
        btnsContainer.addSubview(recorderBtn);
        btnsContainer.addSubview(completeBtn);
    }
    
    func addSubviewConstraints() {
        
        btnsContainer.snp.makeConstraints { (make) in
            make.top.equalTo(view).inset(25);
            make.left.equalToSuperview();
            make.height.equalTo(150);
            make.right.equalToSuperview();
        }
        recorderBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.centerY.equalToSuperview().inset(30);
        }
        playBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(recorderBtn);
            make.right.equalTo(recorderBtn.snp.left).offset(-40);
        }
        completeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(recorderBtn);
            make.left.equalTo(recorderBtn.snp.right).offset(40);
        }
    }
    
    func setupSubviews() {
        //
        self.title = "添加录音";
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "我的录音", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarItemClicked));
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.red];
        //
        playBtn.translatesAutoresizingMaskIntoConstraints = false;
        recorderBtn.translatesAutoresizingMaskIntoConstraints = false;
        completeBtn.translatesAutoresizingMaskIntoConstraints = false;
        
        view.backgroundColor = RGBCOLOR(r: 242.0, 242.0, 255.0, 1.0);
        btnsContainer.backgroundColor = UIColor.white;
        
        recorderBtn.setTitleColor(UIColor.red, for: UIControlState.normal);
        playBtn.setTitleColor(UIColor.red, for: UIControlState.normal);
        completeBtn.setTitleColor(UIColor.red, for: UIControlState.normal);
        playBtn.setTitleColor(UIColor.lightGray, for: UIControlState.disabled);
        completeBtn.setTitleColor(UIColor.lightGray, for: UIControlState.disabled);
        
        playBtn.isEnabled = false;
        completeBtn.isEnabled = false;
        
        recorderBtn.setTitle("录音", for: UIControlState.normal);
        playBtn.setTitle("播放", for: UIControlState.normal);
        completeBtn.setTitle("完成", for: UIControlState.normal);
        
        playBtn.addTarget(self, action: #selector(playBtnClicked(_:)), for: UIControlEvents.touchUpInside);
        recorderBtn.addTarget(self, action: #selector(recorderBtnTouchedDown(_:)), for: UIControlEvents.touchDown);
        recorderBtn.addTarget(self, action: #selector(recorderBtnTouchedUp(_:)), for: UIControlEvents.touchUpInside);
        recorderBtn.addTarget(self, action: #selector(recorderBtnTouchCanceled(_:)), for: UIControlEvents.touchUpOutside);
        
        completeBtn.addTarget(self, action: #selector(completeBtnClicked(_:)), for: UIControlEvents.touchUpInside);
        
    }
}



