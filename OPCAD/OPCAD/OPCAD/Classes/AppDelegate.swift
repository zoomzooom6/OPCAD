//
//  AppDelegate.swift
//  OPCAD
//
//  Created by Vijay Dhanda on 01/12/19.
//  Copyright © 2019 Vijay Dhanda. All rights reserved.
//

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // create variables for database below
    var window: UIWindow?
    var databaseName : String? = "login.db"
    var databasePath : String?
    var users : [MyData] = []



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // setup the path for where db file will be accessed from
        
        // this method creates an array of directories under ~/Documents
         let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
         // ~/Documents is always at index 0
         let documentsDir = documentPaths[0]
         
         // append filename such that path is ~/Documents/MyDatabase.db
         databasePath = documentsDir.appending("/" + databaseName!)
    
         // move onto creating method checkAndCreateDatabase
         checkAndCreateDatabase()
         
         // move on to creating method readDataFromDatabase
         readDataFromDatabase()
         
         return true
    }
    
    func checkAndCreateDatabase()
    {
    // create method as follows
    // first step is to see if the file already exists at ~/Documents/MyDatabase.db
    // if it exists, do nothing and return
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
    
        if success
        {
            return
        }
    
    // if it doesn't (meaning its a first time load) find location of
    // login.db in app file and save the path to it
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
    // copy file login.db from app file into phone at ~/Documents/MyDatabase.db
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
    
    // return to didFinishLaunching (don't forget to call this method there)
    return;
    }
    
    func readDataFromDatabase() // function is used to retrieve data from database
    {
        // empty people array
        users.removeAll()
    
        // define sqlite3 object to interact with db
        var db: OpaquePointer? = nil
        
        // open connection to db file - this is C code
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.databasePath)")
            
            // setup query - entries is the table name you created in step 0
            var queryStatement: OpaquePointer? = nil
            var queryStatementString : String = "select * from entries"
            
            // setup object that will handle data transfer
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                // loop through row by row to extract data
                while( sqlite3_step(queryStatement) == SQLITE_ROW ) {
                
                    // extract columns data, convert from char* to NSString
                    // col 0 - id, col 1 = name, col 2 = email, col 3 = food
                    
                    let cid = sqlite3_column_text(queryStatement, 0)
                    let cpassword = sqlite3_column_text(queryStatement, 1)
                    
                    let id = String(cString: cid!)
                    let password = String(cString: cpassword!)
        
                    // save to data object and add to array
                    let data : MyData = MyData.init()
                    data.initWithData(i: id, p: password)
                    users.append(data)
                    
                    print("Query Result:")
                    print("\(id) | \(password)")
                    
                }
                // clean up
                sqlite3_finalize(queryStatement)
            } else {
                print("SELECT statement could not be prepared")
            }
            
            // close connection
            // move on to ViewController.swift
            sqlite3_close(db);

        } else {
            print("Unable to open database.")
        }
    
    }
    
    func insertIntoDatabase(users : MyData) -> Bool
    {
        // define sqlite3 object to interact with db
        var db: OpaquePointer? = nil
        var returnCode : Bool = true
        
        // open connection to db file - this is C code
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.databasePath)")
            
            // setup query - entries is the table name you created in step 0
            var insertStatement: OpaquePointer? = nil
            var insertStatementString : String = "insert into entries values(?, ?)"
            
            // setup object that will handle data transfer
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
               
           
                // attach items from data object to query
                // **Note need to cast as NSString so you can convert to utf8String.  Not doing this will result in fourth column overwriting second and third column
                let idStr = users.id! as NSString
                let passwordStr = users.password! as NSString
                
                sqlite3_bind_text(insertStatement, 1,idStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, passwordStr.utf8String, -1, nil)

                // execute query
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row. \(rowID)")
                } else {
                    print("Could not insert row.")
                    returnCode = false
                }
                // clean up
                sqlite3_finalize(insertStatement)
            } else {
                print("INSERT statement could not be prepared.")
                returnCode = false
            }
            
            // step 16i - close db connection
            // move on to ViewController.swift
            sqlite3_close(db);
            
        } else {
            print("Unable to open database.")
            returnCode = false
        }
        return returnCode
    }
    
    
    func checkUserCredentials(users : MyData)-> Bool
    {
        // define sqlite3 object to interact with db
        var db: OpaquePointer? = nil
        var returnCode : Bool = true
       
        // open connection to db file - this is C code
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            print("Successfully opened connection to database at \(self.databasePath)")
            
            // setup query - entries is the table name you created in step 0
            var checkStatement: OpaquePointer? = nil
            var checkStatementString : String = "select * from entries where id = ? and password = ?"
            
            // setup object that will handle data transfer
            if sqlite3_prepare_v2(db, checkStatementString, -1, &checkStatement, nil) == SQLITE_OK {
                
                // attach items from data object to query
                // **Note need to cast as NSString so you can convert to utf8String.  Not doing this will result in fourth column overwriting second and third column
                let idStr = users.id! as NSString
                let passwordStr = users.password! as NSString

                sqlite3_bind_text(checkStatement, 1,idStr.utf8String, -1, nil)
                sqlite3_bind_text(checkStatement, 2, passwordStr.utf8String, -1, nil)
                
                // execute query and check the returned values
                if sqlite3_step(checkStatement) == SQLITE_ROW {
                    print("Logged in Successfully.")
                }
                else {
                    print("User not found.")
                    returnCode = false
                }
                // clean up
                sqlite3_finalize(checkStatement)
            }
            else {
                print("INSERT statement could not be prepared.")
                returnCode = false
            }
                        
            // step 16i - close db connection
            // move on to ViewController.swift
            sqlite3_close(db);
        }
        else {
            print("Unable to open database.")
            returnCode = false
        }
        return returnCode
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

