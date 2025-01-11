//
//  StackedCard.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 5/01/25.
//

import SwiftUI

struct Tag: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}

struct People: Identifiable {
    let id = UUID()
    let profilePhoto: String
    let color: Color
}

struct Card: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let tags: [Tag]
    let people: [People]
}

let mockTags = [
    Tag(title: "Late", color: .red),
    Tag(title: "UI Design", color: .green),
    Tag(title: "SwiftUI", color: .gray),
    Tag(title: "In Progress", color: .gray),
    Tag(title: "Development", color: .cyan),
    Tag(title: "Testing", color: .yellow),
    Tag(title: "iOS", color: .blue),
    Tag(title: "Animations", color: .orange),
]

let mockPeople = [
    People(profilePhoto: "memoji", color: Color("blue_light")),
    People(profilePhoto: "profile2", color: Color("green_light")),
    People(profilePhoto: "profile3", color: Color("light_turquoise")),
    People(profilePhoto: "profile4", color: Color("lila_light")),
    People(profilePhoto: "profile5", color: Color("peach_pie")),
    People(profilePhoto: "profile6", color: Color("pink_light")),
    People(profilePhoto: "profile7", color: Color("yellow_light")),
    People(profilePhoto: "profile8", color: Color("lavanda_light")),
    People(profilePhoto: "profile9", color: Color("peach_pie")),
    People(profilePhoto: "profile10", color: Color("green_light")),
]

let mockCards = [
    Card(
        title: "SwiftUI Samples",
        color: .green,
        tags: [mockTags[3], mockTags[5]],
        people: [mockPeople[2], mockPeople[1], mockPeople[3]]
    ),
    Card(
        title: "Build UI Design",
        color: .green,
        tags: [mockTags[0], mockTags[1]],
        people: [mockPeople[2], mockPeople[1]]
    ),
    Card(
        title: "Master Performance",
        color: .cyan,
        tags: [mockTags[3], mockTags[2]],
        people: [mockPeople[0], mockPeople[3], mockPeople[9]]
    ),
    Card(
        title: "Master Networking",
        color: .orange,
        tags: [mockTags[3], mockTags[4]],
        people: [mockPeople[5], mockPeople[6]]
    ),
    Card(
        title: "Explore Animations",
        color: .blue,
        tags: [mockTags[7], mockTags[6]],
        people: [mockPeople[5], mockPeople[3], mockPeople[9]]
    ),
    Card(
        title: "Learn Networking",
        color: .purple,
        tags: [mockTags[2], mockTags[6]],
        people: [mockPeople[6], mockPeople[2]]
    ),
]

struct StackedCard: View {
    @State private var cards = mockCards
    @State var topCards: [Card] = []
    @State private var offset = CGSize.zero
    @State var remainingCards: [Card] = []
    @State var currentIndex: Int = 0
    @State var animated: Bool = false
    private let dragScale: CGFloat = 0.4
    private let maxDragDistance: CGFloat = 200

    var body: some View {
        ZStack {

            Color.black.opacity(1).ignoresSafeArea()
            ForEach(Array(zip(topCards.indices, topCards)), id: \.1.id) {
                index, card in
                let reverseIndex = topCards.count - index - 1
                CardView(card: card, index: reverseIndex)
                    .offset(index == topCards.count - 1 ? offset : .zero)
                    .padding(
                        .top, index == topCards.count - 1 && animated ? 30 : 0
                    )
                    .zIndex(Double(index))
                    .padding(.bottom, (CGFloat(index) * 40))
                    .opacity(
                        index == topCards.count - 1
                            ? 1.0 - min(abs(offset.height) / 200.0, 1.0) : 1.0
                    )
                    .blur(
                        radius: index == topCards.count - 1
                            ? min(abs(offset.height) / 50, 5) : 0
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                withAnimation(.bouncy.speed(1)) {
                                    animated = true
                                }
                                if index == topCards.count - 1 {
                                    let scaledTranslation =
                                        gesture.translation.height * dragScale
                                    if abs(scaledTranslation) <= maxDragDistance
                                        && scaledTranslation <= 0
                                    {
                                        offset = CGSize(
                                            width: 0, height: scaledTranslation)
                                    }
                                }
                            }
                            .onEnded { _ in
                                withAnimation {
                                    animated = false
                                }
                                if index == topCards.count - 1 {
                                    if offset.height < -50 {
                                        removeCard(at: index)
                                    } else {
                                        withAnimation {
                                            offset = .zero
                                        }
                                    }
                                }
                            }
                    )
                   
            }
        }.onAppear {
            topCards = Array(cards.prefix(3))
            remainingCards = Array(cards.dropFirst(3))
        }
    }

    func onChange() {

    }

    func removeCard(at index: Int) {
        withAnimation {
            _ = topCards.remove(at: index)
            if !remainingCards.isEmpty {
                topCards.insert(remainingCards.first!, at: 0)
                remainingCards.removeFirst()
            }
            offset = .zero
        }
    }
}

struct CardView: View {
    var card: Card
    var index: Int

    var body: some View {
        Rectangle()
            .frame(
                width: index == 0 ? 350 : (340 - (CGFloat(index) * 20)),
                height: 180, alignment: .center
            )
            .cornerRadius(15)
            .foregroundStyle(.white)
            .shadow(radius: 1)
            .overlay {
                VStack {
                    VStack {
                        Text("\(card.title)").font(.subheadline.bold()).frame(
                            maxWidth: .infinity, alignment: .leading)
                        HStack {
                            ForEach(card.tags) { tag in
                                Chip(tag: tag)
                            }
                        }.frame(
                            maxWidth: .infinity, maxHeight: 50,
                            alignment: .leading)
                        HStack(spacing: -20) {
                            ForEach(card.people) { person in
                                CircleAvatar(
                                    imageName: person.profilePhoto,
                                    backgroundColor: person.color, size: 50)

                            }
                        }.frame(
                            maxWidth: .infinity, maxHeight: 50,
                            alignment: .leading)
                    }
                }
                .frame(
                    maxWidth: .infinity, maxHeight: .infinity,
                    alignment: .leading
                )
                .padding(.all, 20)
            }

    }

}

struct PressModifier: ViewModifier {
    let onPress: () -> Void
    let onRelease: () -> Void

    func body(content: Content) -> some View {
        content.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    onPress()
                }
                .onEnded { _ in
                    onRelease()
                }
        )
    }
}

extension View {
    func pressEvents(
        onPress: @escaping () -> Void, onRelease: @escaping () -> Void
    ) -> some View {
        modifier(PressModifier(onPress: onPress, onRelease: onRelease))
    }
}

#Preview {
    StackedCard()
}
