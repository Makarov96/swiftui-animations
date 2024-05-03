//
//  ContentView.swift
//  animations
//
//  Created by Steven on 1/05/24.
//

import SwiftUI



struct ContentView: View {
    var body: some View{
        NavigationStack{
            
            NavigationLink( "Airbnb Animation") {
                AirbnbAnimation()
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}







struct BottomSheent:View {
    @Binding var show:Bool
    
    init(show: Binding<Bool>) {
        self._show = show
        
    }
    var body: some View {
        Rectangle()
            .frame(width: .infinity, height: 600)
            .foregroundColor(.white)
            .shadow(radius: 100, x: 40)
            .offset(x: 0, y: show ?  200 : 800)
            .animation(.spring, value: show)
    }
}


struct AirbnbAnimation:View {
    @State var animation:Bool = false
    @State var activateGeneralOpacity:Bool = false
    @State var delayAnimation:Bool = false
    var body: some View {
        
        ZStack{
            
            BottomSheent(show: $animation)
            ZStack{
                Rectangle()
                    .frame(width:animation ? 180 : 90 ,height: animation  ? 210 : 90)
                    .clipShape(.rect(bottomTrailingRadius:animation ? 25 : 10, topTrailingRadius:animation ? 25 : 10))
                    .shadow(color: .black.opacity(activateGeneralOpacity ? 0 : animation ? 0.2 : 0.1),radius: 8)
                    .foregroundColor(.white)
                    .overlay {
                        if activateGeneralOpacity {
                            VStack{
                                CompositionText(primaryText: "51", secondaryText: "reviews")
                                CompositionText(primaryText: "4.84", secondaryText: "Raiting", showIcon: true)
                                CompositionText(primaryText: "2", secondaryText: "Years hosting", showDivider: false)
                            }
                            .transition(.blurReplace())
                        }
                        
                        
                        
                    }
                    .offset(x: animation ?  85 : 15, y: animation ?  80 : 0)
                
                Rectangle()
                    .frame(width:animation ? 180 : /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/ ,height: animation  ? 210 : 100)
                    .clipShape(.rect(bottomTrailingRadius:animation ? 25 : 10, topTrailingRadius:animation ? 25 : 10))
                    .shadow(color: .black.opacity(animation ?   0 : 0.2 ),radius: 5, x: animation ? 2 : 5)
                    .foregroundColor(.white)
                    .overlay {
                        VStack(spacing: 0){
                            ZStack{
                                if activateGeneralOpacity {
                                    Circle()
                                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100, alignment: .center)
                                        .foregroundColor(.red.opacity(0.5))
                                    
                                }
                                
                                Image("memoji")
                                    .resizable().aspectRatio(contentMode: .fit)
                                    .frame(width: 80,height: 80, alignment: .center)
                            }
                            if activateGeneralOpacity {
                                VStack(alignment:.leading,spacing:0){
                                    Text("Steven")
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .font(.system(size: 25))
                                    HStack{
                                        Image(systemName: "medal.fill")
                                        Text("Superhost")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                    }
                                }.transition(.blurReplace())
                            }
                        }
                        .padding([.leading],animation ? 50 : 0)
                        .rotation3DEffect(.degrees(animation ? 180 : 0), axis: (x: 0, y: 1, z: 0),anchor: .center)
                        
                    }
                    .offset(x: animation ? 85 : 5,  y: animation ?  80 : 0)
                
                    .rotation3DEffect(
                        Angle(degrees: animation ? 180  : delayAnimation ?  35 : 10),
                        axis: (x: 0, y: -1, z: 0),
                        anchor: .center,
                        anchorZ: 0.5,
                        perspective: 0.5
                        
                    )
            }
            .compositingGroup()
            .shadow(radius:activateGeneralOpacity ?  /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ : 0)
            
            
            
            
        }
        .onTapGesture {
            
            withAnimation {
                animation.toggle()
            }
            
            if animation == true {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    withAnimation {
                        activateGeneralOpacity.toggle()
                        delayAnimation = false
                    }
                }
                                              
                )
                
            }else {
                activateGeneralOpacity.toggle()
                withAnimation {
                    
                    delayAnimation = false
                }
            }
            if animation == false {
                updateDelayAnimation(delayAnimation: delayAnimation, duration: .now() + 0.60)
            }
        }
        .onAppear(perform: {
            updateDelayAnimation(delayAnimation: delayAnimation)
        })
        
        
    }
    
    func updateDelayAnimation(delayAnimation:Bool, duration: DispatchTime = .now() + 0.45)->Void{
        DispatchQueue.main.asyncAfter(deadline: duration, execute: {
            withAnimation(.easeIn) {
                self.delayAnimation = true
            }
        })
    }
}


struct CompositionText:View {
    var primaryText:String
    var secondaryText:String
    var showDivider:Bool = true
    var showIcon:Bool = false
    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                Text(primaryText)
                    .fontWeight(.heavy)
                    .font(.system(size: 18))
                    .frame( alignment: .leading)
                    .frame( alignment: .leading)
                if showIcon{
                    Spacer()
                        .frame(width: 4)
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 13, height: 13, alignment: .leading)
                        .foregroundColor(.black)
                }
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Text(secondaryText)
                .fontWeight(.medium)
                .font(.system(size: 10))
            
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            if showDivider {
                Divider()
                    .frame( width: 120,height: 0.4)
                    .overlay(.gray.opacity(0.4))
                    .padding([.trailing], 90)
            }
        }
        .frame(alignment: .leading)
        
        .padding([.top], 10)
        .padding([.leading], 100)
        
        
        
    }
}
