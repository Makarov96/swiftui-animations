//
//  Chips.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 6/01/25.
//
import SwiftUI

struct Chip: View {
    var tag: Tag
    var body: some View {
        Text(tag.title)
            .font(.system(size: 15).bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Rectangle().fill(tag.color.opacity(0.2)))
            .cornerRadius(5)
            .foregroundStyle(tag.color)
         
    }
}

#Preview {
    Chip(tag: Tag(title: "In progress", color: .blue))
}
