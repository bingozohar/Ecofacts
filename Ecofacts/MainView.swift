//
//  ContentView.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 05/04/2023.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var topicsCore: FetchedResults<TopicCore>
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var store : EcofactStore
    
    @State private var topics = [Topic]()
    @State private var isPresentingNewTopic = false
    @State private var newTopicData = Topic.Data()
    @State private var showExportButton = true
    @State private var previousScenePhase : ScenePhase?
    
    let loadAction: ()->Void
    let saveAction: ()->Void
    
    private func delete(at offsets: IndexSet) {
        store.topics.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack(path: $topics) {
            List {
                Section {
                    ForEach(store.topics) { topic in
                        NavigationLink(value: topic) {
                            TopicCardView(topic: topic)
                        }
                    }
                    .onDelete(perform: delete)
                    .listRowSeparator(.hidden)
                } header: {
                    Text("Topics")
                }
                
                Section {
                    if showExportButton == true {
                        Button("Export to Local Container") {
                            withAnimation() {
                                showExportButton = false
                                EcofactStore.exportToLocalContainer(topics: store.topics) { result in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation() {
                                            showExportButton = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Ecofacts")
            .navigationDestination(for: Topic.self) { topic in
                TopicDetailView(topic: store.topicBinding(for: topic.id))
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddButtonView(
                        accessibilityLabel: "Nouveau",
                        isPresentingNew: $isPresentingNewTopic
                    )
                }
            }
            .sheet(isPresented: $isPresentingNewTopic) {
                NavigationStack {
                    TopicEditView(data: $newTopicData)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Annuler") {
                                    isPresentingNewTopic = false
                                    newTopicData = Topic.Data()
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Ajouter") {
                                    let newTopic = Topic(data: newTopicData)
                                    store.topics.append(newTopic)
                                    isPresentingNewTopic = false
                                    newTopicData = Topic.Data()
                                }
                            }
                        }
                }
            }
        }
        .onChange(of: scenePhase) { phase in
#if targetEnvironment(macCatalyst)
            print("TUTO")
#endif
            //print(ProcessInfo.processInfo.isMacCatalystApp)
            //print(previousScenePhase)
            //print(phase)
            if let previous = previousScenePhase {
                if previous == .active && phase == .inactive {
                    saveAction()
                }
                else if previous == .background && phase == .inactive {
                    loadAction()
                }
            }
            else {
                //loadAction()
            }
            previousScenePhase = phase
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(loadAction: {}, saveAction: {})
            .environmentObject( { () -> EcofactStore in
                
                let store = EcofactStore()
                store.topics = Topic.samples
                return store
            }())
    }
}
