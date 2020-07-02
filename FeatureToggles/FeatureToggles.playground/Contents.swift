import Foundation

struct ToggleConfiguration {
    let xFeature: Bool
}

protocol FeatureToggle {
    func optional<T: Any>(for path: KeyPath<ToggleConfiguration, Bool>,_ t: T) -> T?
}

class AppFeatureToggle: FeatureToggle {
    private let configuration: ToggleConfiguration

    init(configuration: ToggleConfiguration) {
        self.configuration = configuration
    }

    func optional<T>(for path: KeyPath<ToggleConfiguration, Bool>, _ t: T) -> T? {
        if configuration[keyPath: path] {
            return t
        }
        return nil
    }
}
let configuration = ToggleConfiguration(xFeature: false) //change to true to see diff
let featureToggle: FeatureToggle = AppFeatureToggle(configuration: configuration)

// returning type
let property = featureToggle.optional(for: \.xFeature, 1)
print(property?.advanced(by: 1))

// returning function
func cool() {
    print("Cool")
}
let function = featureToggle.optional(for: \.xFeature, cool)
function?()
