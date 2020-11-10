//
//  DatabaseManager.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 10/11/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import Foundation
import SQLite3

final class DatabaseManager {
    
    private let databasePath: String = "database.sql"
    private(set) var db: OpaquePointer?
    
    init() {
        db = openDatabase()
    }
    
    private func openDatabase() -> OpaquePointer? {
        guard let fileURL = try? FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
            .appendingPathComponent(databasePath) else {
                return nil
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(databasePath)")
            return db
        }
    }
    
    func createTable() {
        let createStatement = """
        CREATE TABLE IF NOT EXISTS sleep(
        start INTEGER PRIMARY KEY,
        end INTEGER NOT NULL);
        """
        
        let sqlString = createStatement
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sqlString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Table created")
            } else {
                print("Table could not be created:\n\(sqlString)")
            }
        } else {
            print("CREATE TABLE statement could not be prepared:\n\(sqlString)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(start: Int, end: Int) {
        let insertStatementString = "INSERT INTO sleep (start, end) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(start))
            sqlite3_bind_int(insertStatement, 2, Int32(end))

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }

    func read() -> [SleepSession] {
        let queryStatementString = "SELECT * FROM sleep;"
        var queryStatement: OpaquePointer? = nil
        var sleepSessions : [SleepSession] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let start = sqlite3_column_int(queryStatement, 1)
                let end = sqlite3_column_int(queryStatement, 2)
                sleepSessions.append(SleepSession(start: Int(start), end: Int(end)))
                print("Query Result:")
                print("\(start) | \(end)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return sleepSessions
    }
    
    func deleteAllRows() {
        let deleteStatementString = "DELETE FROM sleep;"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("All rows deleted from table")
                read()
            } else {
                print("Unable to delete all rows from the table")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
