//
//  File.swift
//  
//
//  Created by shotaro.hirano on 2022/12/22.
//

import Foundation

public enum CompositionalLayoutPattern {
    case grid(numberOfColumn: Int, aspectRatio: CGFloat)
    case horizontalScrolling(size: CGSize)
    case banner(aspectRatio: CGFloat)
    case infiniteScrolling
}
