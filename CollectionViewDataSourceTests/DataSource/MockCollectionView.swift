//
//  MockCollectionView.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/17/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

@testable import CollectionViewDataSource

class MockCollectionView: UICollectionView {
    override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return HeaderCell()
    }
}
