//
//  DatabaseManager.swift
//  babytracker
//
//  Created by Ai-Lyn Tang on 10/11/20.
//  Copyright © 2020 WhimLyn. All rights reserved.
//

import Foundation
import SQLite3

enum Event: String {
    case sleep
    case feed
    case diaper
}

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
    
    func doesTableExist(tableName: String) -> Bool {
        let sqlString = "SELECT name FROM sqlite_master WHERE type='table' AND name='\(tableName)';"
        var doesTableExistStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, sqlString, -1, &doesTableExistStatement,  nil) == SQLITE_OK {
            
            if sqlite3_step(doesTableExistStatement) == SQLITE_ROW {
                return true
            } else {
                print("table does not exist, or there are no rows")
                return false
            }
        } else {
            print("Unable to prepare statement to check if table exists")
        }
        sqlite3_finalize(doesTableExistStatement)
        return false
    }
    
    func createTable() {
        let createStatement = """
        CREATE TABLE IF NOT EXISTS sleep(
        start INTEGER NOT NULL,
        end INTEGER PRIMARY KEY);
        """
        
        let sqlString = createStatement
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sqlString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Table created")
            } else {
                print("Table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
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

    func readAll() -> [SleepSession] {
        let queryStatementString = "SELECT * FROM sleep;"
        var queryStatement: OpaquePointer? = nil
        var sleepSessions : [SleepSession] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let start = sqlite3_column_int(queryStatement, 1)
                let end = sqlite3_column_int(queryStatement, 2)
                sleepSessions.append(SleepSession(start: Int(start), end: Int(end)))
                print("Query Result: \(start) | \(end)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return sleepSessions
    }
    
    func readMostRecent() -> SleepSession? {
        let queryStatementString = "SELECT * FROM sleep ORDER BY end DESC LIMIT 1"
        var queryStatement: OpaquePointer? = nil
        var sleepSession: SleepSession? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let start = sqlite3_column_int(queryStatement, 1)
                let end = sqlite3_column_int(queryStatement, 2)
                print(start)
                print(end)
                sleepSession = SleepSession(start: Int(start), end: Int(end))
            } else {
                print("Error: no rows exist in the table")
            }
        } else {
            print("Error: could not prepare read most recent statement")
        }
        sqlite3_finalize(queryStatement)
        return sleepSession
    }
    
    func deleteAllRows() {
        let deleteStatementString = "DELETE FROM sleep;"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("All rows deleted from table")
            } else {
                print("Unable to delete all rows from the table")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func delete(table: String) {
        let deleteStatementString = "DROP TABLE sleep;"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Table deleted")
            } else {
                print("Table not deleted")
            }
        } else {
            print("Unable to prepare delete table statement")
        }
        sqlite3_finalize(deleteStatement)
    }
}
