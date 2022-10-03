//
//  UserAnnotation.swift
//  Lunar
//
//  Created by Jacob Lucas on 3/21/22.
//

import SwiftUI

struct UserAnnotation: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 42, height: 42)
                    .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                Image("Black Man")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
            }
        }
    }
}

struct UserAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        UserAnnotation()
    }
}
