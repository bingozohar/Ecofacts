//
//  TopicEditView.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 05/04/2023.
//

import SwiftUI

struct TopicEditView: View {
    @Binding var data: Topic.Data
    
    var body: some View {
        Form {
            Section {
                TextField("Topic", text: $data.name, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } header: {
                Text("Informations")
            }
        }
    }
}

struct TopicEditView_Previews: PreviewProvider {
    static var previews: some View {
        TopicEditView(data: .constant(Topic.samples[0].data))
    }
}
