//
//  CircleAvatar.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 6/01/25.
//
import SwiftUI

struct CircleAvatar: View {
    var imageName: String
    var backgroundColor:Color
    var size: CGFloat
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 3))
           
           
    }
}
