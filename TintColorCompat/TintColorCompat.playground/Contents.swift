import UIKit
import PlaygroundSupport

extension UIImage {
    public func withTintColor(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        let rect = CGRect(origin: CGPoint.zero, size: size)

        color.setFill()
        self.draw(in: rect)

        context.setBlendMode(.sourceIn)
        context.fill(rect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}

let view = UIImageView()
let image = UIImage(systemName: "folder.fill")
view.image = image?.withTintColor(color: .red)
view.frame = CGRect(x: 0, y: 0, width: 24, height: 18)

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
