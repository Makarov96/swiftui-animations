//
//  CompositionText.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 3/05/24.
//

import SwiftUI


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
