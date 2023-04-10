//
//  TopicCardView.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 05/04/2023.
//

import SwiftUI

struct TopicCardView: View {
    let topic: Topic
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(topic.name)
                .font(.title2)
            Text("Statements: \(topic.statements.count)")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
}

struct TopicCardView_Previews: PreviewProvider {
    static var previews: some View {
        TopicCardView(topic: Topic.samples[0])
    }
}
