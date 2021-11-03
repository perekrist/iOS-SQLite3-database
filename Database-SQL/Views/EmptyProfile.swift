//
//  EmptyProfile.swift
//  Database-SQL
//
//  Created by Кристина Перегудова on 02.11.2021.
//

import SwiftUI

struct EmptyProfile: View {
  @State var users: [String]
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .center, spacing: 5) {
        ForEach(users, id: \.self) { user in
          Text(user)
        }
      }
    }
  }
}
