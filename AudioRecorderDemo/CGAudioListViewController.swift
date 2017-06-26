//
//  CGAudioListViewController.swift
//  AudioRecorderDemo
//
//  Created by chenguang on 2017/6/25.
//  Copyright © 2017年 chenguang. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class CGAudioListTableCellData: NSObject {
    var audioData:NSData
    var audioName:String
    var isPlaying:Bool
    var currentTime:TimeInterval
    var audioLength:Double
    
    init(_ audioData:NSData,_ audioName:String,_ audioLength: Double,_ isPlaying:Bool) {
        
        self.audioData = audioData;
        self.audioName = audioName;
        self.audioLength = audioLength;
        self.isPlaying = isPlaying;
        self.currentTime = 0.0;
    }
}

class CGAudioListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate {
    //
    var audioPlayer:AVAudioPlayer!
    let cellReuseIdentity = "CGVoiceDataListCell"
    var playingIndex:IndexPath!
    // table
    fileprivate var tableView: UITableView = UITableView()
    var audios = [NSManagedObject]()
    var tableData = [CGAudioListTableCellData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // data
        audios = CGAudioDataManager.sharedInstance.getAllAudioData()!;
        
        for audio in audios {
            let audioData = audio.value(forKey: "audio") as! NSData;
            let audioName = audio.value(forKey: "audioName") as! String;
            let cellData = CGAudioListTableCellData.init(audioData, audioName, Double(audioData.length), false);
            tableData.append(cellData);
        }

        // UI
        self.title = "我的录音";
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.red];        
        self.tableView.register(CGAudioListTableViewCell.self, forCellReuseIdentifier: cellReuseIdentity);
        self.tableView.tableFooterView = UIView();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(self.tableView);
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview();
            make.left.equalToSuperview();
            make.bottom.equalToSuperview();
            make.right.equalToSuperview();
        }
        
    }
    
    // action
    func playAudioDataAtIndexPath(_ indexPath:IndexPath) {
        let cellData = tableData[indexPath.row];
        let playing = cellData.isPlaying;
        cellData.isPlaying = !cellData.isPlaying;
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none);

        if playing {
            audioPlayer.pause();
            cellData.currentTime = audioPlayer.currentTime;
            return;
        } else if cellData.currentTime > 0 {
            audioPlayer.play(atTime: cellData.currentTime+audioPlayer.deviceCurrentTime);
            return;
        }
        
        do {
            try audioPlayer = AVAudioPlayer(data: (cellData.audioData as NSData) as Data);
            audioPlayer.prepareToPlay();
            audioPlayer.play();
            audioPlayer.delegate = self;
            if self.playingIndex != nil {
                self.playingStopedAtIndexPath(self.playingIndex);
            }
            self.playingIndex = indexPath;
        } catch {
        }

    }
    
    func playingStopedAtIndexPath(_ indexPath:IndexPath) {
        let cellData = tableData[self.playingIndex.row];
        cellData.isPlaying = false;
        tableView.reloadData();
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playingStopedAtIndexPath(self.playingIndex);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentity) as! CGAudioListTableViewCell;
        let cellData = tableData[indexPath.row];
        cell.bindData(cellData);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        self.playAudioDataAtIndexPath(indexPath);
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0;
    }

}
