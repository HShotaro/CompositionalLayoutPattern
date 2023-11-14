//
//  File.swift
//  
//
//  Created by shotaro.hirano on 2022/12/22.
//

import Foundation

public enum CompositionalLayoutPattern {
    case selfSizing
    case grid(numberOfColumn: Int, aspectRatio: CGFloat)
    case horizontalScrolling(size: CGSize)
    case horizontalScrollingWithFractionalWidth(fractionalWidth: CGFloat, itemAspectRatio: CGFloat)
    case horizontalScrollingWithFractionalHeight(fractionalHeight: CGFloat, itemAspectRatio: CGFloat)
    case banner(aspectRatio: CGFloat)
    case infiniteScrolling(aspectRatio: CGFloat)
}
