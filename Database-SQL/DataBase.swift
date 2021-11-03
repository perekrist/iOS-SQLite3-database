//
//  DataBase.swift
//  Database-SQL
//
//  Created by Кристина Перегудова on 02.11.2021.
//

import Foundation
import SQLite3

class DataBase {
  var db: OpaquePointer?
  
  init() {
    openDB()
  }
  
  func openDB() {
    if let path = Bundle.main.path(forResource: "db", ofType:"db") {
      if sqlite3_open(path, &db) == SQLITE_OK {
        print("Successfully opened connection to database")
      }
    }
  }
  
  func getUsersAndMessagesCount() -> [(String, Int)] {
    var queryStatement: OpaquePointer?
    let query = """
SELECT profile.user_name, COUNT(user_name) FROM users
INNER JOIN profile ON users.id = profile.user_id
INNER JOIN messages ON users.id = messages.user_id
INNER JOIN attachments ON messages.id = attachments.message_id
GROUP BY users.id
"""
    var users: [(String, Int)] = []
    
    sqlite3_prepare_v2(db, query, -1, &queryStatement, nil)
    while sqlite3_step(queryStatement) == SQLITE_ROW {
      users.append((String(cString: sqlite3_column_text(queryStatement, 0)),
                    Int(sqlite3_column_int(queryStatement, 1))))
    }
    sqlite3_finalize(queryStatement)
    return users
  }
  
  func getTopics() -> [(String, String, Bool)] {
    var queryStatement: OpaquePointer?
    let query = "SELECT topic_title, id FROM topic"
    var topics: [(String, String, Bool)] = []
    
    sqlite3_prepare_v2(db, query, -1, &queryStatement, nil)
    while sqlite3_step(queryStatement) == SQLITE_ROW {
      topics.append((String(cString: sqlite3_column_text(queryStatement, 0)),
                     String(cString: sqlite3_column_text(queryStatement, 1)),
                     false))
    }
    sqlite3_finalize(queryStatement)
    return topics
  }
  
  //email,  name,   topics
  func getUsersWithTopics() -> [(String, String, String)] {
    var queryStatement: OpaquePointer?
    let query = """
SELECT profile.user_name, email, GROUP_CONCAT(topic.topic_title) FROM users
INNER JOIN profile ON profile.user_id = users.id
INNER JOIN profile_topic ON profile_topic.profile_id = profile.id
INNER JOIN topic ON profile_topic.topic_id = topic.id
GROUP BY users.id
"""
    var users: [(String, String, String)] = []
    
    sqlite3_prepare_v2(db, query, -1, &queryStatement, nil)
    while sqlite3_step(queryStatement) == SQLITE_ROW {
      users.append((String(cString: sqlite3_column_text(queryStatement, 0)),
                    String(cString: sqlite3_column_text(queryStatement, 1)),
                    String(cString: sqlite3_column_text(queryStatement, 2))))
    }
    sqlite3_finalize(queryStatement)
    return users
  }
  
  func getEmptyUsers() -> [String] {
    var queryStatement: OpaquePointer?
    let query = """
SELECT users.email from users
INNER JOIN profile ON users.id = profile.user_id
WHERE profile.about_myself is NULL OR profile.avatar is NULL OR profile.user_name IS NULL
"""
    var users: [String] = []
    
    sqlite3_prepare_v2(db, query, -1, &queryStatement, nil)
    while sqlite3_step(queryStatement) == SQLITE_ROW {
      users.append(String(cString: sqlite3_column_text(queryStatement, 0)))
    }
    sqlite3_finalize(queryStatement)
    return users
  }
  
  func getMessagePairs() -> [(Message, Message)] {
    var queryStatement: OpaquePointer?
    let query = """
SELECT * FROM (SELECT
ROW_NUMBER() OVER (Order by messages.created_at) AS row,
profile.user_name, messages.text, messages.created_at,
ROW_NUMBER() OVER (Order by messages1.created_at) AS row1,
profile1.user_name, messages1.text, messages1.created_at FROM messages
INNER JOIN messages AS messages1 ON messages.chat_id == messages1.chat_id
INNER JOIN profile ON messages.user_id = profile.user_id
INNER JOIN profile AS profile1 ON messages1.user_id = profile1.user_id
WHERE ABS(messages.created_at - messages1.created_at) < 900)
WHERE row - row1 = 1
"""
    var messages: [(Message, Message)] = []
    
    sqlite3_prepare_v2(db, query, -1, &queryStatement, nil)
    while sqlite3_step(queryStatement) == SQLITE_ROW {
      messages.append((
        Message(author: String(cString: sqlite3_column_text(queryStatement, 1)),
                text: String(cString: sqlite3_column_text(queryStatement, 2)),
                createdAt: Int(sqlite3_column_int(queryStatement, 3))),
        Message(author: String(cString: sqlite3_column_text(queryStatement, 5)),
                text: String(cString: sqlite3_column_text(queryStatement, 6)),
                createdAt: Int(sqlite3_column_int(queryStatement, 7)))
      ))
    }
    sqlite3_finalize(queryStatement)
    return messages
  }
}

struct Message {
  let author: String
  let text: String
  let createdAt: Int
}
