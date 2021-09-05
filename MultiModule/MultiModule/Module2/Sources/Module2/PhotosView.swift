import SwiftUI
import Interface

public struct PhotosView: View {

    private let images: [Resource] = [
        Resource(name:"img0"),
        Resource(name:"img1"),
        Resource(name:"img2"),
        Resource(name:"img3"),
        Resource(name:"img4"),
        Resource(name:"img5"),
        Resource(name:"img6"),
        Resource(name:"img7"),
        Resource(name:"img8"),
        Resource(name:"img9")
    ]

    public init() {}

    public var body: some View {
        List(images) { image in
            Text("some text \(Int.random(in: 0...10))")
/* TODO: not working
 BundledImage(packageResource: image.name, type: "jpg", bundle: Bundle.module)
 .resizable()
 .frame(height: 192, alignment: .center)
 */
        }
    }
}

public struct Resource: Identifiable {
    public let name: String
    public let id = UUID()
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
