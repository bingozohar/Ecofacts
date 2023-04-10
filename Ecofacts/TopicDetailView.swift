//
//  DetailTopicView.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 05/04/2023.
//

import SwiftUI

struct TopicDetailView: View {
    @Binding var topic: Topic
    
    @State private var topicData = Topic.Data()
    @State private var isPresentingEditTopic = false
    
    @State private var statementData = Topic.Statement.Data()
    @State private var editStatementId : UUID?
    @State private var isPresentingEditStatement = false
    
    private func delete(at offsets: IndexSet) {
        topic.statements.remove(atOffsets: offsets)
    }
    
    var body: some View {
        List {
            Section {
                ForEach($topic.statements) { $st in
                    VStack(alignment: .leading) {
                        Text(st.text)
                        HStack {
                            Button(action: {
                                editStatementId = st.id
                                statementData = st.data
                                isPresentingEditStatement = true
                                
                            }) {
                                Text("[Edit]")
                            }
                            .buttonStyle(.borderless)
                            Link("[Link]", destination: URL(string: st.url) ?? URL(string: ".")!)
                                .buttonStyle(.borderless)
                        }
                    }
                }
                .onDelete(perform: delete)
                .onMove { from, to in
                    topic.statements.move(fromOffsets: from, toOffset: to)
                }
            } header: {
                HStack {
                    Text("Statements")
                    Spacer()
                    AddButtonView(
                        accessibilityLabel: "Nouveau Statement",
                        isPresentingNew: $isPresentingEditStatement
                    )
                }
            }
            Section {
                Button("Editer Nom") {
                    topicData = topic.data
                    isPresentingEditTopic = true
                }
            }
        }
        .navigationTitle(topic.name)
        .sheet(isPresented: $isPresentingEditTopic) {
            NavigationStack {
                TopicEditView(data: $topicData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Annuler") {
                                isPresentingEditTopic = false
                                topicData = Topic.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Mettre à jour") {
                                topic.update(from: topicData)
                                isPresentingEditTopic = false
                                topicData = Topic.Data()
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingEditStatement) {
            NavigationStack {
                StatementEditView(data: $statementData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Annuler") {
                                isPresentingEditStatement = false
                                statementData = Topic.Statement.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Sauvegarder") {
                                //print("Je suis la")
                                if let index = self.topic.statements.firstIndex(where: { $0.id == editStatementId }) {
                                    //print("mise a jour")
                                    //print(statementData)
                                    topic.statements[index].update(from: statementData)
                                }
                                else {
                                    //print("new - data")
                                    //print(statementData)
                                    let newStatement = Topic.Statement(data: statementData)
                                    //print("new - statement")
                                    //print(newStatement)
                                    topic.statements.append(newStatement)
                                }
                                editStatementId = nil
                                statementData = Topic.Statement.Data()
                                isPresentingEditStatement = false
                            }
                        }
                    }
            }
        }
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TopicDetailView(topic: .constant(Topic.samples[0]))
    }
}
