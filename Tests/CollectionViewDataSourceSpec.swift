//
//  CollectionViewDataSourceSpec.swift
//  CollectionViewDataSourceTests
//
//  Created by Sean on 5/15/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick
import UIKit

@testable import SKCollectionViewDataSource

class CollectionViewDataSourceSpec: QuickSpec {
    var cellConfiguration: CellConfiguration<String>!
    var collectionView: UICollectionView!
    var delegate: MockCollectionViewDataSourceDelegate!
    var indexPath: IndexPath!
    let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1"], ["S2R0", "S2R1", "S2R2", "S2R3"]]
    let reuseId = "testReuseId"
    var unitUnderTest: CollectionViewDataSource<String>!

    override func spec() {
        describe("CollectionViewDataSource") {
            beforeEach {
                self.cellConfiguration = CellConfiguration(cell: UICollectionViewCell.self, presenter: nil)
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.itemSize = CGSize(width: 50, height: 50)
                self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: flowLayout)
                self.delegate = MockCollectionViewDataSourceDelegate()
                self.indexPath = IndexPath(item: 0, section: 0)
                self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration)
            }

            context("init(objects:supplementaryViewConfigurations:)") {
                beforeEach {
                    let singleLevelObjects = ["S0R0", "S0R1", "S0R2"]
                    self.unitUnderTest = CollectionViewDataSource(objects: singleLevelObjects)
                }

                it("Should wrap the objects array in an array and set to objects") {
                    expect(self.unitUnderTest.objects.first).to(equal(["S0R0", "S0R1", "S0R2"]))
                }
            }

            context("init(objects:supplementaryViewConfigurations:)") {
                beforeEach {
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects)
                }

                it("Should set the objects array") {
                    expect(self.unitUnderTest.objects.first).to(equal(self.objects.first))
                    expect(self.unitUnderTest.objects.last).to(equal(self.objects.last))
                }
            }

            context("init(objects:cellReuseId:cellPresenter:reusableViewPresenter:)") {
                beforeEach {
                    let singleLevelObjects = ["S0R0", "S0R1", "S0R2"]
                    self.unitUnderTest = CollectionViewDataSource(objects: singleLevelObjects, cellConfiguration: self.cellConfiguration)
                }

                it("Should wrap the objects array in an array and set to objects") {
                    expect(self.unitUnderTest.objects.first).to(equal(["S0R0", "S0R1", "S0R2"]))
                }
            }

            context("init(objects:cellReuseId:cellPresenter:reusableViewPresenter:)") {
                it("Should set the objects array") {
                    expect(self.unitUnderTest.objects.first).to(equal(self.objects.first))
                    expect(self.unitUnderTest.objects.last).to(equal(self.objects.last))
                }
            }

            context("configureSupplementaryView(_:with:at:)") {
                it("should return the view through the configuration's presenter") {
                    let supplementaryView = MockSupplementaryView()
                    let configuration = SupplementaryViewConfiguration<String>(view: UIView.self, viewKind: "", presenter: { (view, section) in
                        expect(view).to(beIdenticalTo(supplementaryView))
                    })

                    self.unitUnderTest.configureSupplementaryView(supplementaryView, with: configuration, at: self.indexPath)
                }

                it("should return the section through the configurations presenter") {
                    let supplementaryView = MockSupplementaryView()
                    let indexPath = IndexPath(item: 0, section: 7)
                    let configuration = SupplementaryViewConfiguration<String>(view: UIView.self, viewKind: "", presenter: { (view, section) in
                        expect(section).to(equal(7))
                    })

                    self.unitUnderTest.configureSupplementaryView(supplementaryView, with: configuration, at: indexPath)
                }
            }

            context("registerCellIfNeeded(collectionView:)") {
                var collectionView: MockCollectionView!

                beforeEach() {
                    collectionView = MockCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                }

                it("Should return the reuse id if the cell configuration has a reuse id") {
                    self.cellConfiguration.reuseId = "TestReuseId"
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration)
                    expect(self.unitUnderTest.registerCellIfNeeded(collectionView: collectionView)).to(equal("TestReuseId"))
                }

                it("Should not call the register methods if the cell configuration has been set") {
                    self.cellConfiguration.reuseId = "TestReuseId"
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration)
                    let _ = self.unitUnderTest.registerCellIfNeeded(collectionView: collectionView)
                    expect(collectionView.registerCellClassCalled).to(beFalse())
                    expect(collectionView.registerCellNibCalled).to(beFalse())
                }

                it("Should call register nib if a nib is provided at init") {
                    self.cellConfiguration = CellConfiguration(cell: UINib(), presenter: nil)
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration)
                    let _ = self.unitUnderTest.registerCellIfNeeded(collectionView: collectionView)
                    expect(collectionView.registerCellClassCalled).to(beFalse())
                    expect(collectionView.registerCellNibCalled).to(beTrue())
                }

                it("Should call register class if a cell class is provided at init") {
                    self.cellConfiguration = CellConfiguration(cell: UICollectionViewCell.self, presenter: nil)
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration)
                    let _ = self.unitUnderTest.registerCellIfNeeded(collectionView: collectionView)
                    expect(collectionView.registerCellClassCalled).to(beTrue())
                    expect(collectionView.registerCellNibCalled).to(beFalse())
                }
            }

            context("registerSupplementaryViewIfNeeded(collectionView:configuration:kind:)") {
                var collectionView: MockCollectionView!

                beforeEach() {
                    collectionView = MockCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                }

                it("Should return the reuse id if the supplementary view has a reuse id") {
                    var supplementaryViewConfig = SupplementaryViewConfiguration<String>(view: UINib(), viewKind: "TestKind", presenter: nil)
                    supplementaryViewConfig.reuseId = "TestReuseId"
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration, supplementaryViewConfigurations: [supplementaryViewConfig])
                    expect(self.unitUnderTest.registerSupplementaryViewIfNeeded(collectionView: collectionView, configuration: supplementaryViewConfig)).to(equal("TestReuseId"))
                }

                it("Should not call the register methods if the reuse id has been set") {
                    var supplementaryViewConfig = SupplementaryViewConfiguration<String>(view: UINib(), viewKind: "TestKind", presenter: nil)
                    supplementaryViewConfig.reuseId = "TestReuseId"
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration, supplementaryViewConfigurations: [supplementaryViewConfig])
                    let _ = self.unitUnderTest.registerSupplementaryViewIfNeeded(collectionView: collectionView, configuration: supplementaryViewConfig)
                    expect(collectionView.registerSupplementaryClassCalled).to(beFalse())
                    expect(collectionView.registerSupplementaryNibCalled).to(beFalse())
                }

                it("Should call register nib if a nib is provided in the configuration") {
                    let supplementaryViewConfig = SupplementaryViewConfiguration<String>(view: UINib(), viewKind: "TestKind", presenter: nil)
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration, supplementaryViewConfigurations: [supplementaryViewConfig])
                    let _ = self.unitUnderTest.registerSupplementaryViewIfNeeded(collectionView: collectionView, configuration: supplementaryViewConfig)
                    expect(collectionView.registerSupplementaryClassCalled).to(beFalse())
                    expect(collectionView.registerSupplementaryNibCalled).to(beTrue())
                }

                it("Should call register class if a class is provided in the configuration") {
                    let supplementaryViewConfig = SupplementaryViewConfiguration<String>(view: UICollectionViewCell.self, viewKind: "TestKind", presenter: nil)
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration, supplementaryViewConfigurations: [supplementaryViewConfig])
                    let _ = self.unitUnderTest.registerSupplementaryViewIfNeeded(collectionView: collectionView, configuration: supplementaryViewConfig)
                    expect(collectionView.registerSupplementaryClassCalled).to(beTrue())
                    expect(collectionView.registerSupplementaryNibCalled).to(beFalse())
                }
            }

            context("supplementaryViewsDictionary(_:)") {
                var supplementaryConfig: SupplementaryViewConfiguration<String>!

                beforeEach() {
                    supplementaryConfig = SupplementaryViewConfiguration(view: UINib(), viewKind: "TestViewKind", presenter: nil)
                }

                it("Should return an empty dictionary if an empty array is passed in") {
                    let inputDictionary: [SupplementaryViewConfiguration<String>] = []
                    expect(CollectionViewDataSource.supplementaryViewsDictionary(inputDictionary).count).to(equal(0))
                }

                it("Should set view kind as the key to the view configuration") {
                    let dictionary = CollectionViewDataSource.supplementaryViewsDictionary([supplementaryConfig])
                    expect(dictionary["TestViewKind"]?.viewKind).to(equal("TestViewKind"))
                }

                it("Should raise an exception if duplicate view kinds are found") {
                    let secondConfig = SupplementaryViewConfiguration<String>(view: UINib(), viewKind: "TestViewKind", presenter: nil)
                    expect(CollectionViewDataSource.supplementaryViewsDictionary([supplementaryConfig, secondConfig])).to(raiseException())
                }
            }

            context("moveFrom(_:to:)") {
                it("Should move the object at the from index path to the to index path") {
                    let fromIndexPath = IndexPath(row: 1, section: 0)
                    let toIndexPath = IndexPath(row: 2, section: 1)
                    self.unitUnderTest.moveFrom(fromIndexPath, to: toIndexPath)
                    let sectionZero = self.unitUnderTest.objects[0]
                    let sectionOne = self.unitUnderTest.objects[1]

                    expect(sectionZero).to(equal(["S0R0", "S0R2"]))
                    expect(sectionOne).to(equal(["S1R0", "S1R1", "S0R1"]))
                }
            }

            context("object(indexPath:)") {
                it("Should return the object at the specified index path") {
                    let indexPath = IndexPath(row: 1, section: 1)

                    expect(self.unitUnderTest.object(indexPath)).to(equal("S1R1"))
                }
            }

            context("collectionView(_:canMoveItemAt:)") {
                it("Should call the delegate if one is set") {
                    self.unitUnderTest.delegate = self.delegate
                    let _ = self.unitUnderTest.collectionView(self.collectionView, canMoveItemAt: self.indexPath)
                    expect(self.delegate?.canMoveItemCalled).to(beTrue())
                }

                it("Should prefer the value from the delegate if one is returned") {
                    self.unitUnderTest.delegate = self.delegate
                    expect(self.unitUnderTest.collectionView(self.collectionView, canMoveItemAt: self.indexPath)).to(beFalse())
                }

                it("Should return true if no delegate is set") {
                    expect(self.unitUnderTest.collectionView(self.collectionView, canMoveItemAt: self.indexPath)).to(beTrue())
                }
            }

            context("collectionView(_:cellForItemAt:)") {
                it("should return a cell from the delegate if one is set") {
                    self.delegate.shouldReturnCell = true
                    self.unitUnderTest.delegate = self.delegate
                    self.collectionView.dataSource = self.unitUnderTest

                    expect(self.unitUnderTest.collectionView(self.collectionView, cellForItemAt: self.indexPath)).to(beAnInstanceOf(MockCell.self))
                }

                it("should return a cell from the collection view if the delegate does not return one") {
                    self.delegate.shouldReturnCell = false
                    self.unitUnderTest.delegate = self.delegate
                    self.collectionView.dataSource = self.unitUnderTest
                    self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.reuseId)

                    expect(self.unitUnderTest.collectionView(self.collectionView, cellForItemAt: self.indexPath)).toNot(beAnInstanceOf(MockCell.self))
                    expect(self.unitUnderTest.collectionView(self.collectionView, cellForItemAt: self.indexPath)).to(beAnInstanceOf(UICollectionViewCell.self))
                }

                it("should return a cell from the collection view if the delegate is not set") {
                    self.collectionView.dataSource = self.unitUnderTest
                    self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.reuseId)

                    expect(self.unitUnderTest.collectionView(self.collectionView, cellForItemAt: self.indexPath)).toNot(beAnInstanceOf(MockCell.self))
                    expect(self.unitUnderTest.collectionView(self.collectionView, cellForItemAt: self.indexPath)).to(beAnInstanceOf(UICollectionViewCell.self))
                }

                it("should pass the cell to the presenter") {
                    self.cellConfiguration = CellConfiguration(cell: UICollectionViewCell.self, presenter: { (cell, object) in
                        expect(cell).toNot(beNil())
                    })

                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration)
                    self.collectionView.dataSource = self.unitUnderTest
                    self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.reuseId)
                    let _ = self.unitUnderTest.collectionView(self.collectionView, cellForItemAt: self.indexPath)
                }

                it("should pass the object to the presenter") {
                    self.cellConfiguration = CellConfiguration(cell: UICollectionViewCell.self, presenter: { (cell, object) in
                        expect(object).to(equal("S0R0"))
                    })

                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration)
                    self.collectionView.dataSource = self.unitUnderTest
                    self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.reuseId)
                    let _ = self.unitUnderTest.collectionView(self.collectionView, cellForItemAt: self.indexPath)
                }
            }

            context("collectionView(_:moveItemAt:to:)") {
                it("should call move row on the delegate") {
                    self.unitUnderTest.delegate = self.delegate
                    self.unitUnderTest.collectionView(self.collectionView, moveItemAt: self.indexPath, to: self.indexPath)
                    expect(self.delegate.moveItemCalled).to(beTrue())
                }
            }

            context("collectionView(_:numberOfItemsInSection:)") {
                it("Should call the delegate if one is set") {
                    self.unitUnderTest.delegate = self.delegate
                    let _ = self.unitUnderTest.collectionView(self.collectionView, numberOfItemsInSection: 0)
                    expect(self.delegate.numberOfItemsCalled).to(beTrue())
                }

                it("Should prefer the value returned by the delegate if one is set") {
                    self.unitUnderTest.delegate = self.delegate
                    expect(self.unitUnderTest.collectionView(self.collectionView, numberOfItemsInSection: 0)).to(equal(1))
                }

                it("Should return a value from the data source if no delegate is set") {
                    expect(self.unitUnderTest.collectionView(self.collectionView, numberOfItemsInSection: 0)).to(equal(3))
                }
            }

            context("optional func collectionView(_:viewForSupplementaryElementOfKind:at:)") {
                it("Should return a supplementary view from the delegate if one is set") {
                    self.delegate.shouldReturnSupplementaryView = true
                    self.unitUnderTest.delegate = self.delegate
                    self.collectionView.dataSource = self.unitUnderTest

                    let supplementaryView = self.unitUnderTest.collectionView(self.collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, at: self.indexPath)

                    expect(supplementaryView).to(beAnInstanceOf(MockSupplementaryView.self))
                }

                it("Should return a supplementary view from the collection view dequeue method if a kind match is found.") {
                    let reusableViewConfiguration = SupplementaryViewConfiguration<String>(view: UIView.self, viewKind: UICollectionElementKindSectionHeader, presenter: nil)
                    self.unitUnderTest = CollectionViewDataSource(objects: self.objects, cellConfiguration: self.cellConfiguration, supplementaryViewConfigurations: [reusableViewConfiguration])
                    let mockCollectionView = MockCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                    let supplementaryView = self.unitUnderTest.collectionView(mockCollectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, at: self.indexPath)

                    expect(supplementaryView).to(beAnInstanceOf(SecondaryMockSupplementaryView.self))
                }
                
                it("Should return an empty supplementary view if the kind does not match any reusableViewConfigurations") {
                    self.delegate.shouldReturnSupplementaryView = false
                    self.unitUnderTest.delegate = self.delegate
                    self.collectionView.dataSource = self.unitUnderTest

                    expect(self.unitUnderTest.collectionView(self.collectionView, viewForSupplementaryElementOfKind: "Unknown Kind", at: self.indexPath)).to(raiseException())
                }
            }

            context("numberOfSections(collectionView:)") {
                it("Should call the delegate if one is set") {
                    self.unitUnderTest.delegate = self.delegate
                    let _ = self.unitUnderTest.numberOfSections(in: self.collectionView)
                    expect(self.delegate.numberOfSectionsCalled).to(beTrue())
                }

                it("Should prefer the value returned by the delegate if one is set") {
                    self.unitUnderTest.delegate = self.delegate
                    expect(self.unitUnderTest.numberOfSections(in: self.collectionView)).to(equal(5))
                }

                it("Should return a value from the data source if no delegate is set") {
                    expect(self.unitUnderTest.numberOfSections(in: self.collectionView)).to(equal(3))
                }
            }
        }
    }
}
