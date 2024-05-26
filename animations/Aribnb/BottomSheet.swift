//
//  BottomSheet.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 3/05/24.
//

import SwiftUI


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
