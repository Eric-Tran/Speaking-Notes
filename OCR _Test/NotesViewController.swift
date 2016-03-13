//
//  NotesViewController.swift
//  OCR _Test
//
//  Created by Eric Tran on 1/16/16.
//  Copyright © 2016 River Inn Technology. All rights reserved.
//

import Foundation

class NotesViewController: UITableViewController {
    var notes: [Note] = Note.all()
    
    weak var cancelButtonDelegate: CancelButtonDelegate?
    
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell")!
        // if the cell has a text label, set it to the model that is corresponding to the row in array
        cell.textLabel?.text = notes[indexPath.row].objective
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes = Note.all()
    
        return notes.count
        
            }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        notes[indexPath.row].destroy()
        notes.removeAtIndex(indexPath.row)
        tableView.reloadData()
    }

//Speech to Text edits for stViewController
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showView", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showView"){
            
            var upcoming: stViewController = segue.destinationViewController as! stViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let textString = notes[indexPath.row].objective as String
            
            upcoming.textString = textString
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated:true)

            
        }
    }
    
    
    
    
    
    
    
    
}