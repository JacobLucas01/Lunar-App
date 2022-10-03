//
//  PostAnnotation.swift
//  Lunar
//
//  Created by Jacob Lucas on 3/21/22.
//

import SwiftUI

struct PostAnnotation: View {
    @Binding var pfp: UIImage
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 54, height: 54)
                    .foregroundColor(.white)
                Image(uiImage: pfp)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
        }
    }
}
