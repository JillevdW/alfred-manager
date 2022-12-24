//
//  BadgeTextView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 24/12/2022.
//

import SwiftUI

struct BadgeTextView: View {
    let text: String
    var color: Color = .green
    
    var body: some View {
        Text(text)
            .foregroundColor(Color(nsColor: .textBackgroundColor))
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background {
                RoundedRectangle(cornerRadius: 4).fill(color)
            }
    }
}

struct BadgeTextView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BadgeTextView(text: "Badge")
                .font(.footnote)
            
            BadgeTextView(text: "Badge", color: .gray)
                .font(.headline)
        }.padding()
    }
}
