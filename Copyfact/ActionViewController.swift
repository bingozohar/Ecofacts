//
//  ActionViewController.swift
//  Copyfact
//
//  Created by Bingo Zohar on 09/04/2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    //com.apple.share-services
    //com.apple.ui-services
    private var url = ""
    private var statement = ""
    
    @IBOutlet weak var doneButton: UIButton!
    //@IBOutlet weak var innerView: UIView!
    //@IBOutlet weak var urlField: UITextField!
    //@IBOutlet weak var statementField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(UTType.propertyList.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.propertyList.identifier) { (dict, error) in
                        guard let dictionary = dict as? NSDictionary else {
                            print("pas de dict")
                            return
                        }
                        guard let values = dictionary.value(forKey: NSExtensionJavaScriptPreprocessingResultsKey) as? NSDictionary else {
                            print("pas de value")
                            return
                        }
                        print(values)
                        self.url = values["url"] as! String
                        self.statement = values["statement"] as! String
                        //self.url.text = values["url"] as? String
                        //self.statement.text = values["statement"] as? String
                    }
                }
            }
        }
        
        doneButton.layer.cornerRadius = 10
        
        /*view.backgroundColor = .clear
        // 2
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        // 3
        let blurView = UIVisualEffectView(effect: blurEffect)
        // 4
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
          blurView.topAnchor.constraint(equalTo: view.topAnchor),
          blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
          blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])*/
    }

    @IBAction func done() {
        let url = self.url
        let statement = self.statement
        UIPasteboard.general.string = statement + "###" + url
        
        
        // Code permettant de faire une sauvegarde dans le fichier JSON directement.
        // Pas utlisé au final
        /*
        let store = EcofactStore()
        if let topics = EcofactStore.load() {
            store.topics = topics
        }
        print("Store count: \(store.topics.count)")
        if let index = store.topics.firstIndex(where: { $0.name == "#Pending" }) {
            store.topics[index].statements.append(Topic.Statement(label: statement!, source: url!, colorInvert: false))
            let nbsaved = EcofactStore.save(topics: store.topics)
            print("Result: \(nbsaved)")
        }
        else {
            print("Not found")
        }
        */
        
        // Return any edited content to the host app.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
