//
//  CGAudioDataManager.swift
//  AudioRecorderDemo
//
//  Created by chenguang on 2017/6/25.
//  Copyright © 2017年 chenguang. All rights reserved.
//

import UIKit
import CoreData

class CGAudioDataManager: NSObject {
    
    static let sharedInstance = CGAudioDataManager()

    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getAllAudioData() -> [NSManagedObject]? {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        do {
            let results = try getContext().fetch(fetchRequest)
            print("numbers of \(results.count)")
            
            for p in (results as! [NSManagedObject]){
                print("name:  \(p.value(forKey: "audioName")!)")
            }
            
            return results as? [NSManagedObject];
        } catch  {
            print(error)
        }
        return nil;
    }
    
    func addOneAudio (_ audioData:NSData, _ audioName:String) {
        let context = self.getContext();
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context);
        let audio = NSManagedObject(entity:entity!,insertInto:context);
        audio.setValue(audioData, forKey: "audio");
        audio.setValue(audioName, forKey: "audioName");
        do {
            try context.save();
            print("an audio saved");
        } catch  {
            print(error);
        }
    }
}

