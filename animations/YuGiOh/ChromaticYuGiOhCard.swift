//
//  ChromaticYuGiOhCard.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 25/05/24.
//

import SwiftUI

struct ChromaticYuGiOhCard: View {
    @ObservedObject var gyroscopeManager = GyroscopeManager()

    var tform: CGAffineTransform {
        
        get {
            var transform = CGAffineTransform.identity
            transform.a = 1
            transform.b = 0
            transform.c = tan( 0.5 )
            transform.d = 1
            transform.tx = 0
            
            transform.ty = 2
            return transform
        }
    }
    
    var perspective: Float {
        get {
            return Float(abs((  gyroscopeManager.roll ) * 60.5))
        }
    }
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            ZStack{
                
                Color(.white).frame(maxWidth: size.width, maxHeight: size.height)
                    .ignoresSafeArea()
                
                VStack(alignment: .center){
                    Image("dark-magician")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, alignment: .center)
                        .modifier(ChromaticColor(perspective: perspective))
                 
                        .projectionEffect(ProjectionTransform(tform))
                        
                        .rotation3DEffect(
                            .degrees(gyroscopeManager.smoothedPitch * 15),
                            axis: (x: 1.0, y: 0.0, z: 0.0),
                            anchor: .center

                        )
                        .rotation3DEffect(
                            .degrees(gyroscopeManager.smoothedRoll * 15),
                            axis: (x: 0.0, y: 1.0, z: 0.0),
                            anchor: .center
                        )
                        .rotation3DEffect(
                            .degrees(gyroscopeManager.smoothedYaw * 15),
                            axis: (x: 0.0, y: 0.0, z: 1.0),
                            anchor: .center

                        )
                        .animation(.easeInOut(duration: 0.2), value: gyroscopeManager.pitch)
                        .animation(.easeInOut(duration: 0.2), value: gyroscopeManager.roll)
                        .animation(.easeInOut(duration: 0.2), value: gyroscopeManager.yaw)
                        .shadow(color: .gray.opacity(0.5), radius: 10, y: 100)
                        .offset(x: -80)
                       
                }
                
            }
        } .ignoresSafeArea()
    }
}

struct ChromaticColor: ViewModifier {
    
    var perspective:Float
    
    func body(content: Content) -> some View {
        content
            .layerEffect(ShaderLibrary.chromatic_abberation_static(.float(perspective),.float(perspective)), maxSampleOffset: .zero)
        
    }
}


#Preview {
    ChromaticYuGiOhCard()
}
