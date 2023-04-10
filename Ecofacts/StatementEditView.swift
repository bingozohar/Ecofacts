//
//  StatementEditView.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 05/04/2023.
//

import SwiftUI

struct StatementEditView: View {
    @Binding var data: Topic.Statement.Data
    
    var body: some View {
        Form {
            Section {
                TextField("Statement", text: $data.text, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } header: {
                Text("Statement")
            }
            Section {
                TextField("URL", text: $data.url)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } header: {
                Text("Source")
            }
            
            Section {
                Button("Import Copyfact") {
                    if let copyfact = UIPasteboard.general.string {
                        let split = copyfact.split(separator: "###")
                        if split.count == 2 {
                            data.text = String(split[0])
                            data.url = String(split[1])
                        }
                    }
                    //topicData = topic.data
                    //isPresentingEditTopic = true
                }
            }
        }
    }
}

struct StatementEditView_Previews: PreviewProvider {
    static var previews: some View {
        StatementEditView(data: .constant(Topic.samples[0].statements[0].data))
    }
}
