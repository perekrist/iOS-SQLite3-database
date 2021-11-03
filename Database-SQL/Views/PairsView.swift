//
//  PairsView.swift
//  Database-SQL
//
//  Created by Кристина Перегудова on 03.11.2021.
//

import SwiftUI

struct PairsView: View {
  @State var messagePairs: [(Message, Message)]
  
  var body: some View {
    ScrollView(.vertical) {
      ForEach(messagePairs, id: \.0.createdAt) { pair in
        HStack {
          VStack(spacing: 10) {
            Text(pair.0.author)
              .bold()
            Text(secondsToHoursMinutesSeconds(seconds: pair.0.createdAt))
            Text(pair.0.text)
              .italic()
              .multilineTextAlignment(.center)
          }.padding()
          Spacer()
          VStack(spacing: 10) {
            Text(pair.1.author)
              .bold()
            Text(secondsToHoursMinutesSeconds(seconds: pair.1.createdAt))
            Text(pair.1.text)
              .italic()
              .multilineTextAlignment(.center)
          }.padding()
        }.background(Color.blue.opacity(0.3))
          .cornerRadius(15)
          .padding(.horizontal)
      }
    }
  }
  
  func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(seconds))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM hh:mm:ss"
    return dateFormatter.string(from: date)
  }
}
