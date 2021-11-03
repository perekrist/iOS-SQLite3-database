//
//  TopicsView.swift
//  Database-SQL
//
//  Created by Кристина Перегудова on 02.11.2021.
//

import SwiftUI

struct TopicsView: View {
  @State var topics: [(String, String, Bool)]
  @State var users: [(String, String, String)]
  
  @State private var usersTopics: [[String]] = []
  @State private var sortedUsers: [(String, String, String)] = []
  
  var body: some View {
    var width = CGFloat.zero
    var height = CGFloat.zero
    VStack {
      GeometryReader { geo in
        ZStack(alignment: .topLeading, content: {
          ForEach(topics, id: \.1) { topic in
            Text(topic.0)
              .padding(.horizontal, 8)
              .foregroundColor(topic.2 ? .white : .blue)
              .font(.system(size: 20).bold())
              .background(!topic.2 ? Color.blue.opacity(0.3) : Color.blue)
              .clipShape(Capsule())
              .overlay(
                Capsule()
                  .stroke(.blue, lineWidth: 1)
              )
              .padding([.top, .trailing], 9)
              .alignmentGuide(.leading) { dimension in
                if (abs(width - dimension.width) > geo.size.width) {
                  width = 0
                  height -= dimension.height
                }
                let result = width
                if topic.1 == topics.last!.1 {
                  width = 0
                } else {
                  width -= dimension.width
                }
                return result
              }
              .alignmentGuide(.top) { dimension in
                let result = height
                if topic.1 == topics.last!.1 {
                  height = 0
                }
                return result
              }
              .onTapGesture {
                if let index = topics.firstIndex(where: { $0.1 == topic.1 }) {
                  topics[index].2.toggle()
                  
                  let selectedTopics = topics.filter { $0.2 }.map { $0.0 }
                  sortedUsers = Array(users.enumerated().filter { index, value in
                    return Set(usersTopics[index]).intersection(Set(selectedTopics)).count == selectedTopics.count
                  }).map { $0.element }
                }
              }
          }
        }).padding()
          .padding(.top, -30)
      }
      ScrollView(.vertical) {
        ForEach(sortedUsers, id: \.1) { user in
          VStack(alignment: .leading) {
            HStack {
              Text(user.0)
                .bold()
              Text(user.1)
            }.padding()
            Text(user.2)
            Rectangle()
              .frame(width: UIScreen.main.bounds.width - 32, height: 1)
              .background(Color.gray)
          }.padding()
          .id(user.0)
        }
      }.padding(.top, -170)
    }.onAppear {
      self.sortedUsers = users
      self.usersTopics = users.compactMap { $0.2 }
      .map { $0.replacingOccurrences(of: ",", with: " ") }
      .map { $0.split(separator: " ") }
      .map { $0.map { String($0) } }
    }
  }
}
