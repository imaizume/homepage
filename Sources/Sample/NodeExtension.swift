import Foundation
import Plot

extension Node where Context: HTMLContext {
    static func `class`(_ classType: StaticClass) -> Node {
        .class(classType.rawValue)
    }

    static func `class`(_ classType: DynamicClass) -> Node {
        .class(classType.rawValue)
    }

    static func `class`(_ classTypes: [StaticClass]) -> Node {
        .class(classTypes.map { $0.rawValue }.joined(separator: " "))
    }

    static func `class`(_ classTypes: [DynamicClass]) -> Node {
        .class(classTypes.map { $0.rawValue }.joined(separator: " "))
    }

    static func `class`(_ classTypes: [Any]) -> Node {
        let classStrings = classTypes.compactMap { classType -> String? in
            if let staticClass = classType as? StaticClass {
                return staticClass.rawValue
            } else if let dynamicClass = classType as? DynamicClass {
                return dynamicClass.rawValue
            } else if let stringClass = classType as? String {
                return stringClass
            }
            return nil
        }
        return .class(classStrings.joined(separator: " "))
    }
}
