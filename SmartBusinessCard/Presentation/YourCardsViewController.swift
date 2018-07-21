//
//  ViewController.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 12/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//

import UIKit
import CoreData

class YourCardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var cards = [Card]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.alwaysBounceVertical = true
        loadData()
        if cards.count == 0 {
            setupData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setupData() {
        let context = CoreDataStack.stack.persistentContainer.viewContext
        let markBuilder = CardBuilder(withCardName: "Mark")
        markBuilder.add(otherNames: "Zuckerberg")
        markBuilder.add(image: "Zuck")
        let mark = markBuilder.build()
        
        let jackBuilder = CardBuilder(withCardName: "Jack")
        jackBuilder.add(image: "Jack")
        let jack = jackBuilder.build()
        
        _ = Message(card: mark!, text: "Hey, cool app!", read: false)
        _ = Message(card: mark!, text: "Maybe you should come work for me...", read: false)

        
        cards += [mark!, jack!]
        
        do {
            try(context.save())
        }
        catch let err {
            print(err)
        }
    }
    
    func loadData() {
        let context = CoreDataStack.stack.persistentContainer.viewContext
        
        let fetchRequest = Card.createFetchRequest()
        let dateOfLastMessageSortDescriptor = NSSortDescriptor(key: "dateOfLastMessage", ascending: false)
        let dateAddedSortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [ dateOfLastMessageSortDescriptor, dateAddedSortDescriptor]
        do {
            cards = try(context.fetch(fetchRequest))
        }
        catch let err {
            print(err)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell
        cell?.card = cards[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "messageSegue", sender: cards[indexPath.row])
        
        let vc = UIStoryboard(name: "Messages", bundle: nil).instantiateInitialViewController() as? MessagesViewController
        vc?.card = cards[indexPath.row]
        if let controller = vc {
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "messageSegue":
            if let vc = segue.destination as? MessagesViewController {
                vc.card = sender as? Card
            }
        default: break
        }
    }
    

}

class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messagePreviewLabel: UILabel!
    @IBOutlet weak var dateOfLastMessageLabel: UILabel!
    
    private var message: Message?
    
    var card: Card? {
        didSet {
            setupViews()
        }
    }
    
     private func setupViews() {
        let context = CoreDataStack.stack.persistentContainer.viewContext
        let fetchRequest = Message.createFetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "card.id", card!.id as CVarArg)
        do {
            let messages = try(context.fetch(fetchRequest))
            message = messages.first
        }
        catch let err {
            print(err)
            return
        }
        
        setupImageView()
        setupNameLabel()
        setupMessagePreview()
        setupDate()
        
        
       
    }
    
    private func setupImageView() {
        let imageName = card?.cardImageName ?? "DefaultCardImage"
        profileImageView.image = UIImage(named: imageName)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 34
        profileImageView.layer.masksToBounds = true
    }
    
    private func setupNameLabel() {
        guard let setCard = card else {
            return
        }
        nameLabel.text = "\(setCard.firstName)"
        if let extraNames = setCard.otherNames {
            nameLabel.text! += " \(extraNames)"
        }
    }
    
    private func setupMessagePreview() {
        guard let setCard = card else {
            return
        }
        var messageText: String
        if let text = message?.text{
            messageText = "\(setCard.firstName): \(text)"
        }
        else {
            messageText = "You added \(setCard.firstName)'s card!"
        }
        
        let read = message?.read ?? true
        if !read {
            let font = UIFont.boldSystemFont(ofSize: messagePreviewLabel.font.pointSize)
            messagePreviewLabel.font = font
            messagePreviewLabel.textColor = #colorLiteral(red: 0.1992851496, green: 0.1992851496, blue: 0.1992851496, alpha: 1)
        }
        
        messagePreviewLabel.text = messageText
    }
    
    private func setupDate() {
        guard let setCard = card else {
            return
        }
        var dateString: String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        if let date = message?.date {
            dateString = dateFormatter.string(from: date)
        }
        else {
            dateString = dateFormatter.string(from: setCard.dateAdded)
        }
        
        dateOfLastMessageLabel.text = dateString
    }
    
}

