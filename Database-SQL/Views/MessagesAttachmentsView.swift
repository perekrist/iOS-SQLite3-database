//
//  MessagesAttachmentsView.swift
//  Database-SQL
//
//  Created by Кристина Перегудова on 02.11.2021.
//

import SwiftUI

struct MessagesAttachmentsView: View {
  @State var users: [(String, Int)]
  
  var body: some View {
    VStack {
      HStack {
        Text("User name")
        Spacer()
        Text("Messages count")
      }.padding()
      ForEach(users, id: \.0) { user in
        HStack {
          Text(user.0)
          Spacer()
          Text("\(user.1)")
        }
      }.padding()
      Spacer()
    }
  }
}
