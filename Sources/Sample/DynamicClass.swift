//
//  DynamicClass.swift
//  homepage
//
//  Created by tomohiro-imaizumi on 2025/07/21.
//

enum DynamicClass: RawRepresentable {
    init?(rawValue _: String) {
        return nil
    }

    typealias RawValue = String

    case ukWidth(Int, Int, ScreenSize?)
    case ukMargin(Directionality?)
    case ukPadding(PaddingSize?)
    case ukText(TextAlignment)

    enum ScreenSize: String {
        case s
        case m
        case l
    }

    enum Directionality: String {
        case top
        case bottom
        case left
        case right
    }

    enum PaddingSize: String {
        case small
        case medium
        case large
    }

    enum TextAlignment: String {
        case left
        case center
        case right
        case justify
    }

    var rawValue: String {
        switch self {
        case let .ukWidth(numerator, denominator, screenSize):
            let name = "uk-width-\(numerator)-\(denominator)"
            guard let screenSize else {
                return name
            }
            return "\(name)@\(screenSize)"

        case .ukMargin(let directionality):
            let name = "uk-margin"
            guard let directionality = directionality else {
                return name
            }
            return [name, directionality.rawValue].joined(separator: "-")

        case .ukPadding(let paddingSize):
            let name = "uk-padding"
            guard let paddingSize else {
                return name
            }
            return "\(name)-\(paddingSize.rawValue)"

        case .ukText(let textAlignment):
            return "uk-text-\(textAlignment.rawValue)"
        }
    }
}
