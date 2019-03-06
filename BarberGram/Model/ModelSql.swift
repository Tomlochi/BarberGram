//
//  ModelSql.swift
//  BarberGram
//
//  Created by admin on 06/03/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import Foundation



class ModelSql {
    
    var database: OpaquePointer? = nil
    
    
    
    init() {
        
        // initialize the DB
        
        let dbFileName = "database2.db"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            
            .userDomainMask).first{
            
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {

                print("Failed to open db file: \(path.absoluteString)")

                return
                
            }

            dropTables()
            
            createTables()
            
        }
        
    }
    
    func createTables() {

        User.createTable(database: database);

    }

    func dropTables(){
   
    }
 
    
}

