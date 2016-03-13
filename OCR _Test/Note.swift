//
//  Note.swift
//  OCR _Test
//
//  Created by Eric Tran on 1/16/16.
//  Copyright © 2016 River Inn Technology. All rights reserved.
//

import Foundation

class Note: NSObject, NSCoding {
    static var key: String = "Notes"
    static var schema: String = "theList"
    var objective: String
    var createdAt: NSDate
    // use this init for creating a new Task
    init(obj: String) {
        objective = obj
        createdAt = NSDate()
    }
    // MARK: - NSCoding protocol
    // used for encoding (saving) objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(objective, forKey: "objective")
        aCoder.encodeObject(createdAt, forKey: "createdAt")
    }
    // used for decoding (loading) objects
    required init?(coder aDecoder: NSCoder) {
        objective = aDecoder.decodeObjectForKey("objective") as! String
        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
        super.init()
    }
    //MARK: Queries
    static func all() -> [Note] {
        var notes = [Note]()
        let path = Database.dataFilePath(Note.schema)
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                notes = unarchiver.decodeObjectForKey(Note.key) as! [Note]
                unarchiver.finishDecoding()
            }
        }
        return notes
    }
    func save() {
        var notesFromStorage = Note.all()
        var exists = false
        for var i = 0; i < notesFromStorage.count; ++i {
            if notesFromStorage[i].createdAt == self.createdAt {
                notesFromStorage[i] = self
                exists = true
            }
        }
        if !exists {
            notesFromStorage.append(self)
        }
        Database.save(notesFromStorage, toSchema: Note.schema, forKey: Note.key)
    }
    func destroy() {
        var notesFromStorage = Note.all()
        for var i = 0; i < notesFromStorage.count; ++i {
            if notesFromStorage[i].createdAt == self.createdAt {
                notesFromStorage.removeAtIndex(i)
            }
        }
        Database.save(notesFromStorage, toSchema: Note.schema, forKey: Note.key)
    }
    
}