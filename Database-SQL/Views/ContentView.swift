//
//  ContentView.swift
//  Database-SQL
//
//  Created by Кристина Перегудова on 02.11.2021.
//

import SwiftUI

struct ContentView: View {
  @State var dataBase = DataBase()
  
  var body: some View {
    NavigationView {
      VStack(alignment: .center, spacing: 40) {
        NavigationLink {
          MessagesAttachmentsView(users: dataBase.getUsersAndMessagesCount())
        } label: {
          Text("имена пользователей, которые хоть раз отправляли сообщения с вложением + число таких сообщений")
        }
        NavigationLink {
          TopicsView(topics: dataBase.getTopics(), users: dataBase.getUsersWithTopics())
        } label: {
          Text("список пользователей по топикам")
        }
        NavigationLink {
          PairsView(messagePairs: dataBase.getMessagePairs())
        } label: {
          Text("пары последовательных сообщений")
        }
        NavigationLink {
          EmptyProfile(users: dataBase.getEmptyUsers())
        } label: {
          Text("пользователи с незаполненным профилем")
        }
        Spacer()
      }.padding()
    }
  }
}
