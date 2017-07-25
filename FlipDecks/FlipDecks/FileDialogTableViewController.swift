//
//  FileDialogTableViewController.swift
//  Browse
//
//  Created by Nicola Greth on 31.05.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for file dialog
class FileDialogTableViewController: UITableViewController {
    
    //stores all files that the user can choose
    var files : [String] = []
    
    //file that the user chose
    var selectedFile : String = ""
    
    //URL of documents folder
    var documentsFolderURL : URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    //lists content of documents directory
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listDirectoryContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //saves content of FlipDecks directory in string array files
    func listDirectoryContent() {
        do {
            //loop over all files in FlipDecks directory and append all .txt files
            let allFiles = try FileManager.default.contentsOfDirectory(atPath: documentsFolderURL.path)
            for file in allFiles {
                //only .txt files will be shown
                if (file.contains(".txt")) {
                    files.append(file)
                }
            }
            //sort files alphabetically for better user experience :)
            files = files.sorted()
        } //if there are no contents
        catch {
            print("no files yet")
        }
    }
    
    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //row count of tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    //show available files in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //current cell 
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath)
        cell.textLabel?.text = files[indexPath.row]
        return cell
    }
    
    
    //get selected file
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFile = files[indexPath.row]
    }
    
    //give selected file to OpenFileViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let openFileDestination = segue.destination as? OpenFileViewController
        openFileDestination?.selectedFile = self.selectedFile
    }
}
