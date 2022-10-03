//
//  PostSkeletonLoader.swift
//  Lunar
//
//  Created by Jacob Lucas on 2/7/22.
//

import SwiftUI

struct PostSkeletonLoader: View {
    
    private struct Constants {
        static let duration: Double = 0.9
        static let minOpacity: Double = 0.25
        static let maxOpacity: Double = 1.0
        static let cornerRadius: CGFloat = 2.0
    }
    
    @State private var opacity: Double = Constants.minOpacity
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 20) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .opacity(opacity)
                        .transition(.opacity)
                        .frame(width: 36, height: 36)
                    Spacer()
                    Image(systemName: "paperplane")
                        .font(.system(size: 18))
                        .foregroundColor(Color(.label))
                }
                Text("Lunar")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
            }
            .padding(.vertical, 10)
            .frame(width: UIScreen.main.bounds.width - 30)
            Divider()
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0..<3) { _ in
                    VStack(spacing: 0) {
                        HStack {
                            Circle()
                                .fill(Color(.systemGray5))
                                .opacity(opacity)
                                .transition(.opacity)
                                .frame(width: 30, height: 30)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .opacity(opacity)
                                .transition(.opacity)
                                .frame(width: 180, height: 30)
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .opacity(opacity)
                            .transition(.opacity)
                            .padding(.horizontal)
                            .frame(height: 85)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .opacity(opacity)
                            .transition(.opacity)
                            .padding(.horizontal)
                            .padding(.top, 4)
                            .frame(height: 40)
                    }
                    .padding(.vertical)
                }
                Spacer()
            }
            .disabled(true)
        }
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: Constants.duration)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            withAnimation(repeated) {
                self.opacity = Constants.maxOpacity
            }
        }
        .background(colorScheme == .dark ? Color(.systemGray6) : Color.white)
    }
}

struct PostSkeletonLoader_Previews: PreviewProvider {
    static var previews: some View {
        PostSkeletonLoader()
    }
}




//            VStack(spacing: 0) {
//                VStack(alignment: .leading, spacing: 16) {
//                    HStack(spacing: 12) {
//                        Image(systemName: "person.crop.circle.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 30, height: 30)
//                            .clipShape(Circle())
//                        Text("Jacob Lucas")
//                            .font(.system(size: 17, weight: .medium))
//                        HStack(spacing: 5) {
//                            Image(systemName: "clock")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 14, height: 14)
//                                .foregroundColor(Color(.systemGray))
//                            Text("5 min")
//                                .font(.system(size: 14))
//                                .foregroundColor(Color(.systemGray))
//                        }
//                        Spacer(minLength: 0)
//                        Button {
//
//                        } label: {
//                            Image(systemName: "ellipsis")
//                                .foregroundColor(Color(.systemGray))
//                        }
//                    }
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Hey what is everyone up to?")
//                            .font(.system(size: 18))
//                            .fontWeight(.medium)
//                        Text("Blaaaab blaaa randommmm texttttt")
//                            .font(.system(size: 16))
//                        HStack {
//                            Image(systemName: "location")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 15, height: 15)
//                                .foregroundColor(Color(.systemGray))
//                                .frame(maxWidth: .greatestFiniteMagnitude)
//                            Button {
//
//                            } label: {
//                                HStack(spacing: 6) {
//                                    Text("0")
//                                        .font(.system(size: 15))
//                                        .foregroundColor(Color(.systemGray))
//                                    Image(systemName: "hand.thumbsup")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 15, height: 15)
//                                        .foregroundColor(Color(.systemGray))
//                                }
//                                .frame(maxWidth: .greatestFiniteMagnitude)
//                            }
//                            Button {
//
//                            } label: {
//                                HStack(spacing: 6) {
//                                    Text("0")
//                                        .font(.system(size: 15))
//                                        .foregroundColor(Color(.systemGray))
//                                    Image(systemName: "hand.thumbsdown")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 15, height: 15)
//                                        .foregroundColor(Color(.systemGray))
//                                }
//                                .frame(maxWidth: .greatestFiniteMagnitude)
//                            }
//                                Image(systemName: "bubble.right")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 15, height: 15)
//                                    .foregroundColor(Color(.systemGray))
//                                    .frame(maxWidth: .greatestFiniteMagnitude)
//
//                        }
//                        .padding(.top, 14)
//                    }
//                }
//                .padding()
//                Divider()
//                    .padding(.horizontal)
//            }
