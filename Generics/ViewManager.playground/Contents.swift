import UIKit
import PlaygroundSupport

protocol ViewRepresentable {
    associatedtype View: UIView
    func update(view: View)
}

protocol ViewDelegate: class {
    associatedtype Representable: ViewRepresentable
    func representation<View>(representables: [Representable]) -> Representable where View == Representable.View
}

class ViewManager<View, Delegate: ViewDelegate, Representation> where Delegate.Representable == Representation, View == Representation.View {

    let delegate: Delegate
    let representations: [Representation]

    init(delegate: Delegate, representations: [Representation]) {
        self.delegate = delegate
        self.representations = representations
    }

    func update(view: View, traits: UITraitCollection) {
        let target = delegate.representation(representables: representations)
        target.update(view: view)
    }
}

class LabelDelegate: ViewDelegate {
    typealias Representable = AnyLabelRepresentation

    func representation(representables: [Representable]) -> Representable {
        return representables[Int.random(in: 0..<representables.count)]
    }
}

class AnyLabelRepresentation: ViewRepresentable {
    typealias View = UILabel
    func update(view: UILabel) { fatalError() }
}

class GrayLabelRepresentation: AnyLabelRepresentation {
    override func update(view: UILabel) {
        view.backgroundColor = .gray
    }
}

class BlackLabelRepresentation: AnyLabelRepresentation {
    override func update(view: UILabel) {
        view.backgroundColor = .black
    }
}

class RedLabelRepresentation: AnyLabelRepresentation {
    override func update(view: UILabel) {
        view.backgroundColor = .red
    }
}

let labelManager = ViewManager<UILabel, LabelDelegate, AnyLabelRepresentation>(delegate: LabelDelegate(), representations: [GrayLabelRepresentation(), BlackLabelRepresentation(), RedLabelRepresentation()])

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 18))
label.textColor = .white
label.text = "Hi!"
labelManager.update(view: label, traits: UITraitCollection())

let button = UIButton(type: .system)
button.frame = CGRect(x: 0, y: 22, width: 60, height: 40)
button.backgroundColor = .lightGray
button.setTitle("update", for: .normal)
button.setTitleColor(.black, for: .selected)
class Responder: NSObject {
    @objc func update() {
        labelManager.update(view: label, traits: UITraitCollection())
    }
}
let responder = Responder()
button.addTarget(responder, action: #selector(Responder.update), for: .touchUpInside)
button.layer.cornerRadius = 10
let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 62))
view.addSubview(label)
view.addSubview(button)
view.backgroundColor = .clear

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

