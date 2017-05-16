//
//  ReorderableViewController.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/16/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class ReorderableViewController: UIViewController {

    var dataSource: CollectionViewDataSource<String>?

    @IBOutlet weak var collectionView: UICollectionView!

    func longPress(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }

            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            guard let gestureView = gesture.view else {
                break
            }

            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gestureView))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let reuseId = "ReorderableViewControllerReuseId"

        let textCellNib = UINib(nibName: "TextCell", bundle: Bundle.main)
        collectionView.register(textCellNib, forCellWithReuseIdentifier: reuseId)

        let array = [["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona"], ["California", "Colorado", "Connecticut"], ["District of Columbia", "Delaware"], ["Florida"], ["Georgia", "Guam"], ["Hawaii"], ["Iowa", "Idaho", "Illinois", "Indiana"], ["Kansas", "Kentucky"], ["Louisiana"], ["Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana"], ["North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York"], ["Ohio", "Oklahoma", "Oregon"], ["Pennsylvania", "Puerto Rico"], ["Rhode Island"], ["South Carolina", "South Dakota"], ["Tennessee", "Texas"], ["Utah"], ["Virginia", "Virgin Islands", "Vermont"], ["Washington", "Wisconsin", "West Virginia", "Wyoming"]]

        dataSource = CollectionViewDataSource(objects: array, cellReuseId: reuseId) { (cell, object) in
            guard let cell = cell as? TextCell else {
                return
            }

            cell.label.text = object
        }

        collectionView.dataSource = dataSource
        dataSource?.delegate = self

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ReorderableViewController.longPress(gesture:)))
        self.collectionView.addGestureRecognizer(longPressRecognizer)
    }
}

extension ReorderableViewController: CollectionViewDataSourceDelegate {
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataSource?.moveFrom(sourceIndexPath, to: destinationIndexPath)
    }
}
