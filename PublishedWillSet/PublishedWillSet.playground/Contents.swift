import Foundation
import Combine

//FROM https://developer.apple.com/documentation/combine/published

class Weather {
    @Published var temperature: Double
    init(temperature: Double) {
        self.temperature = temperature
    }
}

let weather = Weather(temperature: 20)
var cancellable = weather.$temperature
    .sink() {
        print ("Temperature readed: \(weather.temperature)")
        print ("Temperature received: \($0)")
}
weather.temperature = 25

