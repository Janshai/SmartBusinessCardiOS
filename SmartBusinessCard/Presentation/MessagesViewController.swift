//
//  MessagesViewController.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 21/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var card: Card!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        card.messages.forEach({$0.read = true})
        CoreDataStack.stack.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        var title = card.firstName
        if let otherNames = card.otherNames {
            title += " " + otherNames
        }
        self.title = title
        
        // TODO: animate this
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "message", for: indexPath) as? MessageCell
        let messages = card.messages
        cell?.message = messages[messages.index(messages.startIndex, offsetBy: indexPath.row)]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100.0)
    }
    

}

class MessageCell: UICollectionViewCell {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var message: Message! {
        didSet {
            setupViews()
        }
    }
    
    
    func setupViews() {
        messageLabel.text = message.text
    }
}
