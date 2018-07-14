//
//  ViewController.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 12/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//

import UIKit

class YourCardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var cards = [Card]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.alwaysBounceVertical = true
        setupData()
        
    }
    
    func setupData() {
        let mark = Card(firstName: "Mark", otherNames: "Zuckerberg")
        mark.cardImageName = "Zuck"
        let message = Message(text: "Hey, nice app!", card: mark)
        mark.messages += [message]
        cards += [mark]
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
    

}

class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messagePreviewLabel: UILabel!
    @IBOutlet weak var dateOfLastMessageLabel: UILabel!
    
    var card: Card? {
        didSet {
            if let c = card {
                setupViews(withCard: c)
            }
            
        }
    }
    
    private func setupViews(withCard c: Card) {
        setupImageView(withCard: c)
        setupNameLabel(withCard: c)
        setupMessagePreview(withCard: c)
        setupDate(withCard: c)
       
    }
    
    private func setupImageView(withCard c: Card) {
        let imageName = c.cardImageName ?? "DefaultCardImage"
        profileImageView.image = UIImage(named: imageName)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 34
        profileImageView.layer.masksToBounds = true
    }
    
    private func setupNameLabel(withCard c: Card) {
        nameLabel.text = "\(c.firstName)"
        if let extraNames = c.otherNames {
            nameLabel.text! += " \(extraNames)"
        }
    }
    
    private func setupMessagePreview(withCard c: Card) {
        var message: String
        if let text = c.messages.first?.text {
            message = "\(c.firstName): \(text)"
        }
        else {
            message = "You added \(c.firstName)'s card!"
        }
        
        messagePreviewLabel.text = message
    }
    
    private func setupDate(withCard c: Card) {
        var dateString: String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        if let date = c.messages.first?.date {
            dateString = dateFormatter.string(from: date)
        }
        else {
            dateString = dateFormatter.string(from: c.dateAdded)
        }
        
        dateOfLastMessageLabel.text = dateString
    }
    
}

