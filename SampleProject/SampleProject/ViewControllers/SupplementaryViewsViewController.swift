import SKCollectionViewDataSource
import UIKit

class SupplementaryViewsViewController: UIViewController {

    var dataSource: CollectionViewDataSource<String>?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let array = [["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona"], ["California", "Colorado", "Connecticut"], ["District of Columbia", "Delaware"], ["Florida"], ["Georgia", "Guam"], ["Hawaii"], ["Iowa", "Idaho", "Illinois", "Indiana"], ["Kansas", "Kentucky"], ["Louisiana"], ["Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana"], ["North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York"], ["Ohio", "Oklahoma", "Oregon"], ["Pennsylvania", "Puerto Rico"], ["Rhode Island"], ["South Carolina", "South Dakota"], ["Tennessee", "Texas"], ["Utah"], ["Virginia", "Virgin Islands", "Vermont"], ["Washington", "Wisconsin", "West Virginia", "Wyoming"]]

        let textCellNib = UINib(nibName: "TextCell", bundle: Bundle.main)
        let cellConfiguration = CellConfiguration<String>(cell: textCellNib) { (cell, object) in
            guard let cell = cell as? TextCell else {
                return
            }

            cell.label.text = object
        }

        let headerNib = UINib(nibName: "HeaderCell", bundle: Bundle.main)
        let headerConfiguration = SupplementaryViewConfiguration<String>(view: headerNib, viewKind: UICollectionElementKindSectionHeader) { (view, section) in
            guard let view = view as? HeaderCell else {
                return
            }

            var firstLetter: String? = nil

            if let firstWord = self.dataSource?.object(IndexPath(item: 0, section: section)) {
                firstLetter = firstWord.substring(to: firstWord.index(firstWord.startIndex, offsetBy: 1))
            }

            view.label.text = firstLetter
        }

        let footerNib = UINib(nibName: "FooterCell", bundle: Bundle.main)
        let footerConfiguration = SupplementaryViewConfiguration<String>(view: footerNib, viewKind: UICollectionElementKindSectionFooter) { (view, section) in
            guard let view = view as? FooterCell else {
                return
            }

            view.backgroundColor = .red
        }

        dataSource = CollectionViewDataSource(objects: array, cellConfiguration: cellConfiguration, supplementaryViewConfigurations: [headerConfiguration, footerConfiguration])
        
        collectionView.dataSource = dataSource

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: 100, height: 50)
            layout.footerReferenceSize = CGSize(width: 100, height: 4)
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
}
