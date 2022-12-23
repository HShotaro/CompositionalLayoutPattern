import UIKit

public class HSCollectionView: UICollectionView {
    public init () {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUpCompositionalLayout(patterns: [CompositionalLayoutPattern]) {
        self.collectionViewLayout = createCompositionalLayout(patterns: patterns) ?? UICollectionViewLayout()
    }
    
    private func createCompositionalLayout(patterns: [CompositionalLayoutPattern]) -> UICollectionViewCompositionalLayout? {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { section, environment in
            guard section < patterns.count, !patterns.isEmpty else {
                return nil
            }
            let supplementaryViews = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
                )
            ]
            switch patterns[section] {
            case .banner(let aspectRatio):
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(aspectRatio)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(aspectRatio)),
                    subitem: item,
                    count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 4
                section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                return section
            case .grid(let numberOfColumn, let aspectRatio):
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1 / CGFloat(numberOfColumn) * aspectRatio)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1 / CGFloat(numberOfColumn) * aspectRatio)),
                    subitem: item,
                    count: numberOfColumn
                )
                group.interItemSpacing = .fixed(4)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 4
                section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                section.boundarySupplementaryItems = supplementaryViews
                return section
            case .horizontalScrolling(let size):
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(size.width), heightDimension: .absolute(size.height)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(size.width), heightDimension: .absolute(size.height)),
                    subitem: item,
                    count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 4
                section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                section.boundarySupplementaryItems = supplementaryViews
                section.orthogonalScrollingBehavior = .continuous
                return section
            case .infiniteScrolling(let aspectRatio):
                let itemFractionalwidth: CGFloat = 0.7
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalwidth), heightDimension: .fractionalWidth(aspectRatio)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalwidth), heightDimension: .fractionalWidth(aspectRatio)),
                    subitem: item,
                    count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 4
                section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                section.boundarySupplementaryItems = supplementaryViews
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.visibleItemsInvalidationHandler = { visibleItems, point, environment in
                    guard visibleItems.count > 2 else {
                        return
                    }
//                    let initialPointX = section.contentInsets.leading - environment.container.contentSize.width * (1 - itemFractionalwidth) / 2
//                    let pointXPerOneItemScroll = environment.container.contentSize.width * itemFractionalwidth + section.interGroupSpacing
                    
                    visibleItems.forEach { [weak self] item in
                        guard let cell = self?.cellForItem(at: item.indexPath) else { return }
                        self?.transformScale(cell: cell, offsetX: point.x, collectionViewWidth: environment.container.contentSize.width)
                    }
                }
                return section
            }
        }, configuration: configuration())
        return layout
    }
    
    private func configuration() -> UICollectionViewCompositionalLayoutConfiguration {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        config.interSectionSpacing = 10
        return config
    }
    
    private func transformScale(cell: UICollectionViewCell, offsetX: CGFloat, collectionViewWidth: CGFloat) {
        let cellCenterX:CGFloat = self.convert(cell.center, to: nil).x - offsetX
        let screenCenterX:CGFloat = collectionViewWidth / 2
        let reductionRatio:CGFloat = -0.0009
        let maxScale:CGFloat = 1
        let cellCenterDisX:CGFloat = abs(screenCenterX - cellCenterX)
        let newScale = reductionRatio * cellCenterDisX + maxScale
        cell.transform = CGAffineTransform(scaleX:newScale, y:newScale)
    }
}
