//
//  ContentView.swift
//  animations
//
//  Created by Steven on 1/05/24.
//

import SwiftUI


extension CGAffineTransform {
    
}

struct ContentView: View {
    
  

    var body: some View{
                NavigationStack{
        
                    NavigationLink( "Airbnb animation") {
                        AirbnbAnimation()
                    }
                    NavigationLink("Chromatic animation"){
                        ChromaticYuGiOhCard()
                        
                    }
                }
        
     
        
    }
    
    
}






#Preview {
    ContentView()
}
struct TimeVaryingColorShader: ViewModifier {
    
    private let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content.visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.timeVaryingColor(
                        .float2(proxy.size),
                        .float(startDate.timeIntervalSinceNow)
                    ))
            }
        }
    }
}




/**
 ---------
 BUILDING
 ---------
 */
struct FlipBoardAnimation:View {
    @State private var percent = 0.0
    @State private var degress = 0.0
    @State private var isEditing = false
    var body: some View {
        GeometryReader{
            let size = $0.size
                 
            VStack(spacing: 0){
                
                Rectangle()
                    .frame(height: size.height / 2)
                    .foregroundColor(.black)
                
                
                Rectangle()
                    .frame(height: size.height / 2)
                    .foregroundColor(.black)
                    .rotation3DEffect(
                        .degrees(degress),
                        axis: (x: 1.0, y: 0.0, z: 0.0)
                        ,
                        anchor: .top, perspective: 0.0
                        
                    )
                
                
                
                
                
            }
            
            .compositingGroup()
            
            .frame(width: size.width, height: size.height)
            
    
            
            SliderObserver(speed: $percent, completer: { updated in
                withAnimation {
                    degress = (1.80 * updated)
                }
            })
            .background(.yellow)
            .frame(height: size.height * 0.9,alignment: .bottom)
        }   .ignoresSafeArea()
        
    }
}

typealias Completer = (Double) -> Void




struct SliderObserver:View {
    var completer:Completer
    @Binding var speed:Double
    init( speed: Binding<Double>, completer: @escaping Completer) {
        self.completer = completer
        self._speed = speed
    }
    
    var body: some View {
        Slider(
            value: Binding(get: { speed },
                           set: {
                               
                               speed = $0
                               
                           }),
            in: 0...100
            
            
        ).onChange(of: speed) {
            completer(speed)
        }
        
    }
}

