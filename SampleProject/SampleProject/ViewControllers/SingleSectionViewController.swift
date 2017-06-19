//
//  SingleSectionViewController.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/15/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import SKCollectionViewDataSource
import UIKit

class SingleSectionViewController: UIViewController {

    var dataSource: CollectionViewDataSource<String>?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let array = ["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]

        let textCellNib = UINib(nibName: "TextCell", bundle: Bundle.main)
        let cellConfiguration = CellConfiguration<String>(cell: textCellNib) { (cell, object) in
            guard let cell = cell as? TextCell else {
                return
            }

            cell.label.text = object
        }

        dataSource = CollectionViewDataSource(objects: array, cellConfiguration: cellConfiguration)

        collectionView.dataSource = dataSource
    }
}
