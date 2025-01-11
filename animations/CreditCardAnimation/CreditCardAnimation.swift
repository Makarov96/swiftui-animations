//
//  CreditCardAnimation.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 23/03/25.
//

import SwiftUI


struct CreditCardAnimation: View {
    
    @State
    var viewModel = CreditCardViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    CreditCardList(viewModel: viewModel)
                        .frame(width: geo.size.width, height: 500)
                    CreditCardDetails(viewModel: viewModel)
                }
                
            }
        }
    }
}


struct CreditCardDetails: View {
    @Bindable
    var viewModel: CreditCardViewModel
    
    var body: some View {
        VStack{
            Text(viewModel.currentCard.cardCategory.rawValue)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.headline)
                .padding(.vertical,5)
                .animation(.linear, value: viewModel.currentIndex)
            Text(viewModel.currentCard.cardDescription)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.caption)
                .padding(.horizontal,32)
                .animation(.linear, value: viewModel.currentIndex)
            
            HStack(spacing: 15) {
                Spacer(minLength: 40)
                
                
                ForEach(0..<viewModel.currentCard.backgroundStyleOptions.count, id: \.self) { index in
                    let options = viewModel.currentCard.backgroundStyleOptions[index]
                    switch(options){
                    case .gradient(let colors):
                        ZStack {
                            CustomMeshGradientView(colors: colors)
                                .mask(
                                    Circle()
                                        .frame(width: 50, height: 50)
                                )
                                .frame(width: 50, height: 50)
                        }
                        .opacity(viewModel.currentStyleIndex == index ? 1.0 : 0.6)
                        .scaleEffect(viewModel.currentStyleIndex == index ? 1.2 : 1.0)
                        .animation(.spring(), value: viewModel.currentStyleIndex)
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectStyle(at: index)
                            }
                        }
                        
                    case .normal(let color):
                        Circle()
                            .fill(color)
                            .frame(width: 50, height: 50)
                            .opacity(viewModel.currentStyleIndex == index ? 1.0 : 0.6)
                            .scaleEffect(viewModel.currentStyleIndex == index ? 1.2 : 1.0)
                            .animation(.spring(), value: viewModel.currentStyleIndex)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectStyle(at: index)
                                }
                            }
                    }
                }
                Spacer(minLength: 40)
            }
            .padding(.horizontal)
            .frame(height: 80)
            
        }
    }
}
struct CreditCardList: View {
    var viewModel: CreditCardViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack{
                ForEach(0..<viewModel.cards.count, id: \.self) { index in
                    CreditCard(
                        model: viewModel.cards[index], backgroundColor: viewModel.currentIndex == index ? viewModel.currentStyle : viewModel.cardStyle(at: index)
                    )
                    .scrollTransition(axis: .horizontal) { content, phase in
                        content
                            .rotation3DEffect(
                                .degrees(phase.value * 180),
                                axis: (x: 0, y: 1, z: 0),
                                anchor: .center,
                                anchorZ: 0.0,
                                perspective: 0.3
                            )
                    }
                    .padding(.trailing, 50)
                    .id(index)
                }
                
            }
            
            .scrollTargetLayout()
            
        }
        .contentMargins(.horizontal, 50)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: Binding(
            get: { viewModel.currentIndex },
            set: { newIndex in
                guard let newIndex = newIndex, newIndex >= 0, newIndex < viewModel.cards.count else { return }
                viewModel.selectCard(at: newIndex)
            }
        ))
        
    }
}




#Preview {
    CreditCardAnimation()
}


struct CreditCard : View {
    var model: CreditCardModel
    var backgroundColor: CardStyleOption
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image("chip")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45, height:35)
                
            }.frame(width: .infinity, height: .infinity, alignment: .top)
            Spacer()
            Text(model.cardNumber)
                .font(.system(size: 22, weight: .semibold, design: .default))
                .foregroundColor(.white)
                .padding(.bottom,80)
            
            HStack{
                VStack{
                    Text("Expires \(model.expiryDate)")
                        .font(.system(size: 14, weight: .medium, design: .default ))
                        .foregroundColor(.white)
                    Text(model.owner)
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(model.cradBrand.imagePath).resizable().aspectRatio(contentMode: .fit).frame(width: 70, height: 70)
                
            }
            
        }
        .padding(.all,20)
        .frame(width: 280, height: 450)
        .background {
            switch (backgroundColor) {
            case .normal(let color):
                color
            case .gradient(let colors):
                PastelMeshGradientView(colors: colors)
            }
            
        }
        .cornerRadius(10)
    }
    
}

struct CustomMeshGradientView: View {
    var colors: [Color]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<min(colors.count, 7), id: \.self) { index in
                    
                    let positions: [(x: Double, y: Double)] = [
                        (0.1, 0.9),
                        (0.25, 0.5),
                        (0.6, 0.3),
                        (0.8, 0.2),
                        (0.9, 0.8),
                        (0.3, 0.8),
                        (0.5, 0.5)
                    ]
                    let safeIndex = index % positions.count
                    let position = positions[safeIndex]
                    
                    RadialGradient(
                        gradient: Gradient(colors: [colors[index], colors[index].opacity(0)]),
                        center: UnitPoint(x: position.x, y: position.y),
                        startRadius: 0,
                        endRadius: geometry.size.width * (0.6 + Double(index) * 0.05)
                    )
                }
            }
        }
    }
}

struct PastelMeshGradientView: View {
   
    var colors: [Color]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(white: 0.98)
                
                ForEach(0..<min(colors.count, 7), id: \.self) { index in

                    let positions: [(x: Double, y: Double, scale: Double)] = [
                        (0.2, 0.3, 1.0),
                        (0.2, 0.5, 0.9),
                        (0.3, 0.7, 0.8),
                        (0.5, 0.5, 0.7),
                        (0.65, 0.2, 0.7),
                        (0.8, 0.5, 0.9),
                        (0.75, 0.8, 1.0)
                    ]
 
                    let safeIndex = index % positions.count
                    let position = positions[safeIndex]
                    
                    RadialGradient(
                        gradient: Gradient(colors: [
                            colors[index].opacity(0.7),
                            colors[index].opacity(0)
                        ]),
                        center: UnitPoint(x: position.x, y: position.y),
                        startRadius: 0,
                        endRadius: max(geometry.size.width, geometry.size.height) * position.scale
                    )
                }
            }
        }
    }
}

struct CreditCardModel: Hashable {
    var id: String = UUID().uuidString
    var cardNumber:String
    var owner:String
    var expiryDate:String
    var cradBrand: CardBrand
    var cardCategory: CardCategory
    var backgroundStyleOptions: [CardStyleOption]
    var cardDescription: String

    
    init(
        cardNumber: String,
        owner: String,
        expiryDate: String,
        cardType: CardBrand,
        cardCategory: CardCategory,
        backgroundStyleOptions: [CardStyleOption] = [],
        cardDescription: String
    ) {
        self.cardNumber = cardNumber
        self.owner = owner
        self.expiryDate = expiryDate
        self.cradBrand = cardType
        self.cardCategory = cardCategory
        self.backgroundStyleOptions = backgroundStyleOptions
        self.cardDescription = cardDescription
        self.backgroundStyleOptions = backgroundStyleOptions
    }
}



enum CardStyleOption: Hashable {
    case normal(color:Color)
    case gradient(colors:[Color])
}



enum CardBrand: String {
    case visa
    case mastercard
    case westerunion
    case applepay
    
}

extension CardBrand {
    var imagePath: String {
        switch self {
        case .visa:
            return "CardProviderOptions/visa"
        case .mastercard:
            return "CardProviderOptions/mastercard"
        case .westerunion:
            return "CardProviderOptions/wester-union"
        case .applepay:
            return "CardProviderOptions/apple-pay"
        }
    }
}


enum CardCategory: String {
    case standard
    case silver
    case gold
    case platinum
    case black
    case signature
    case infinite
    case titanium
    case premium
    case plus
    case ultraPremium
    case metal
}
let mockCreditCards: [CreditCardModel] = [
    CreditCardModel(
        cardNumber: "4539 8765 1234 5678",
        owner: "Juan Pérez López",
        expiryDate: "12/26",
        cardType: .visa,
        cardCategory: .standard,
        backgroundStyleOptions: [.normal(color: Color.gray),.normal(color: Color.blue)], cardDescription: "Tarjeta básica con beneficios esenciales para el día a día"
    ),
    CreditCardModel(
        cardNumber: "5412 9876 5432 1098",
        owner: "María González Sánchez",
        expiryDate: "09/28",
        cardType: .mastercard,
        cardCategory: .premium,
        backgroundStyleOptions: [
            .gradient(colors: [
                Color(hex: "FFBB00"), Color(hex: "FF8A3C"),Color(hex: "FF3377"),
                Color(hex: "E04D95"), Color(hex: "85C1E9"),Color(hex: "3D85C6"),
                Color(hex: "9B59B6")
            ]),
            .normal(color: .red)], cardDescription: "Tarjeta con múltiples beneficios en viajes y compras internacionales"
    ),
    CreditCardModel(
        cardNumber: "6789 4321 8765 4321",
        owner: "Carlos Rodríguez Fernández",
        expiryDate: "03/27",
        cardType: .westerunion,
        cardCategory: .plus,
        backgroundStyleOptions: [
            .gradient(colors:  [
                Color(hex: "FF9500"), Color(hex: "FF7B29"), Color(hex: "FF5E3A"),
                Color(hex: "E83E8C"), Color(hex: "A64DB8"), Color(hex: "6F42C1"),
                Color(hex: "0063B1")
            ]),
            .normal(color: .blue)
        ], 
        cardDescription: "Diseñada para transferencias internacionales con bajas comisiones"
        
    ),
    CreditCardModel(
        cardNumber: "4916 8735 9821 6540",
        owner: "Ana Martínez Álvarez",
        expiryDate: "11/29",
        cardType: .visa,
        cardCategory: .ultraPremium,
        backgroundStyleOptions: [
            .gradient(colors:  [
                Color(hex: "000000"), Color(hex: "1B262C"), Color(hex: "2C3A47"),
                Color(hex: "6D214F"), Color(hex: "B33771"), Color(hex: "D63031"),
                Color(hex: "FD7272")
            ]),
            .normal(color: Color.brown),
            .normal(color: Color.gray)
        ], cardDescription: "Experiencia de lujo con concierge personal 24/7 y acceso a salas VIP"
    ),
    CreditCardModel(
        cardNumber: "5187 6243 8795 1062",
        owner: "Luis Gómez Díaz",
        expiryDate: "07/30",
        cardType: .mastercard,
        cardCategory: .metal,
        backgroundStyleOptions: [
            .gradient(colors: [
                Color(hex: "E74C3C"), Color(hex: "FF7675"), Color(hex: "FF9F43"),
                Color(hex: "F5F6FA"), Color(hex: "AACBFF"), Color(hex: "54A0FF"),
                Color(hex: "0A3D62")
            ]),
            .normal(color: Color.red)
        ],
        cardDescription: "Fabricada en metal con recompensas premium en restaurantes y hoteles"
    ),
    CreditCardModel(
        cardNumber: "6102 3456 7890 1234",
        owner: "Laura Hernández Moreno",
        expiryDate: "04/25",
        cardType: .westerunion,
        cardCategory: .standard,
        backgroundStyleOptions: [], 
        cardDescription: "Tarjeta para uso cotidiano con programa de puntos básico"
    ),
    CreditCardModel(
        cardNumber: "9753 8642 0864 2975",
        owner: "Pedro Jiménez Torres",
        expiryDate: "08/27",
        cardType: .applepay,
        cardCategory: .premium,
        backgroundStyleOptions: [], 
        cardDescription: "Integración perfecta con el ecosistema Apple y recompensas en tecnología"
    ),
    CreditCardModel(
        cardNumber: "4532 1678 8901 2345",
        owner: "Sofía Ruiz Ramírez",
        expiryDate: "01/28",
        cardType: .visa,
        cardCategory: .plus,
        backgroundStyleOptions: [], 
        cardDescription: "Beneficios exclusivos en viajes y seguros de compra mejorados"
    ),
    CreditCardModel(
        cardNumber: "5304 8765 1234 5670",
        owner: "Miguel Alonso Gutiérrez",
        expiryDate: "06/27",
        cardType: .mastercard,
        cardCategory: .titanium,
        backgroundStyleOptions: [],
        cardDescription: "Acceso exclusivo a eventos premium y asistencia de viaje ilimitada"
    ),
    CreditCardModel(
        cardNumber: "8642 9753 1086 4209",
        owner: "Lucía Romero García",
        expiryDate: "10/26",
        cardType: .applepay,
        cardCategory: .gold,
        backgroundStyleOptions: [
         
        ], 
        cardDescription: "Diseño exclusivo con material sostenible y cashback en servicios digitales"
    ),
]

struct AppleMeshGradient: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(MeshGradientView())
    }
}

struct MeshGradientView: View {
    let purpleColor = Color(hex: "9061c2")
    let pinkColor = Color(hex: "d686a4")
    let orangeColor = Color(hex: "e9b06e")
    let yellowColor = Color(hex: "e3d66d")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [purpleColor, purpleColor.opacity(0)]),
                    center: UnitPoint(x: 0.1, y: 0.9),
                    startRadius: 0,
                    endRadius: geometry.size.width * 0.8
                )
                
                RadialGradient(
                    gradient: Gradient(colors: [pinkColor, pinkColor.opacity(0)]),
                    center: UnitPoint(x: 0.25, y: 0.5),
                    startRadius: 0,
                    endRadius: geometry.size.width * 0.7
                )
                
                RadialGradient(
                    gradient: Gradient(colors: [orangeColor, orangeColor.opacity(0)]),
                    center: UnitPoint(x: 0.6, y: 0.3),
                    startRadius: 0,
                    endRadius: geometry.size.width * 0.9
                )
                
                
                RadialGradient(
                    gradient: Gradient(colors: [yellowColor, yellowColor.opacity(0)]),
                    center: UnitPoint(x: 0.8, y: 0.2),
                    startRadius: 0,
                    endRadius: geometry.size.width * 0.7
                )
                
                RadialGradient(
                    gradient: Gradient(colors: [yellowColor.opacity(0.8), yellowColor.opacity(0)]),
                    center: UnitPoint(x: 0.9, y: 0.8),
                    startRadius: 0,
                    endRadius: geometry.size.width * 0.6
                )
            }
        }
    }
}

extension View {
    func appleMeshGradient() -> some View {
        self.modifier(AppleMeshGradient())
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

