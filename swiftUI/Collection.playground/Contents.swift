import SwiftUI
import PlaygroundSupport

extension Color {
    static var random: Color {
        Color(red: .random(in: 0...1),
              green: .random(in: 0...1),
              blue: .random(in: 0...1))
    }
}

extension String {
    private static let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    static func random(length: Int = 5) -> String {
        return String((0..<length).compactMap { _ in letters.randomElement() })
    }
}

extension Array {
    func pack(chunks: Int) -> [Array] {
        guard chunks > 0 else {
            return [Array]()
        }
        let quotient = count / chunks
        let remainder = count % chunks
        let size: Int = quotient + (remainder > 0 ? 1 : 0)
        var container = [Array]()
        (0..<size).forEach { chunk in
            var items = Array()
            (0..<chunks).forEach { offset in
                let index = (chunk * chunks) + offset
                if index < count {
                    items.append(self[index])
                }
            }
            container.append(items)
        }
        return container
    }
}

struct Card: Identifiable {
    let id = UUID()
    let title: String
}

struct CardView: View {
    private let card: Card

    init(card: Card) {
        self.card = card
    }

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.random)
            Text(card.title)
                .font(.title2)
        }

    }
}

struct RowView: View {
    private let cards: [Card]
    private let width: CGFloat
    private let height: CGFloat
    private let hSpacing: CGFloat

    init(cards: [Card], width: CGFloat, height: CGFloat, hSpacing: CGFloat) {
        self.cards = cards
        self.width = width
        self.height = height
        self.hSpacing = hSpacing
    }

    var body: some View {
        HStack(spacing: hSpacing) {
            ForEach(cards) { card in
                CardView(card: card)
                    .frame(width: width, height: height)
            }
        }.padding()
    }
}

class CollectionViewModel: ObservableObject {
    let cards: [Array<Card>]
    let itemsPerRow: Int

    init(cards: [Card], itemsPerRow: Int) {
        self.itemsPerRow = itemsPerRow
        self.cards = cards.pack(chunks: itemsPerRow)
    }
}

// Non LAZY version
struct CollectionView: View {
    private let height: CGFloat
    private let hSpacing: CGFloat
    private let viewModel: CollectionViewModel

    init(height: CGFloat, hSpacing: CGFloat, viewModel: CollectionViewModel) {
        self.height = height
        self.hSpacing = hSpacing
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<viewModel.cards.count) { index in
                        RowView(cards: viewModel.cards[index],
                                width: rowWidth(geometry, viewModel.itemsPerRow),
                                height: height,
                                hSpacing: hSpacing)
                    }
                }
            }
        }
    }

    private func rowWidth(_ geometry: GeometryProxy, _ numItemsPerRow: Int) -> CGFloat {
        let itemsPerRow: CGFloat = CGFloat(numItemsPerRow)
        let width: CGFloat = (geometry.size.width - hSpacing * (itemsPerRow + 1)) / itemsPerRow
        return width
    }
}

let cards: [Card] = (0...40)
    .map { _ in Card(title: String.random())}
let viewModel = CollectionViewModel(cards: cards,
                                    itemsPerRow: 2)
let view = CollectionView(height: 300,
                          hSpacing: 16,
                          viewModel: viewModel)
    .frame(width: 500, height: 900)

//TODO: uncomment to see non lazy version. comment lazy version
//PlaygroundPage.current.setLiveView(view)

// LAZY version
class LazyCollectionViewModel: ObservableObject {
    let cards: [Card]
    let itemsPerRow: Int

    init(cards: [Card], itemsPerRow: Int) {
        self.itemsPerRow = itemsPerRow
        self.cards = cards
    }
}

struct LazyCollectionView: View {
    private let height: CGFloat
    private let spacing: CGFloat
    private let columns: [GridItem]
    private let viewModel: LazyCollectionViewModel

    init(height: CGFloat, spacing: CGFloat, viewModel: LazyCollectionViewModel) {
        self.height = height
        self.spacing = spacing
        self.viewModel = viewModel
        columns = Array(repeating: .init(.flexible()), count: viewModel.itemsPerRow)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(cards) { card in
                    CardView(card: card)
                        .frame(height: height)
                }
            }.padding()
        }
    }
}


let lazyViewModel = LazyCollectionViewModel(cards: cards,
                                    itemsPerRow: 2)
let lazyView = LazyCollectionView(height: 300,
                                  spacing: 16,
                                  viewModel: lazyViewModel)
    .frame(width: 500, height: 900)

//TODO: uncomment to see non lazy version. comment non lazy version
PlaygroundPage.current.setLiveView(lazyView)
