//
//  FeedView.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/25/21.
//

import SwiftUI
import CoreLocation
import Combine
import MapKit
import GeoFire

struct FeedView: View {
    
   // var posts = [PostModel]()
    
    @State var ellipsis: Bool = false
    @State var report: Bool = false
    @State var verifyDeletion: Bool = false
    @State var openNotificationView: Bool = false
    @State var openNewPostView: Bool = false
    @State var openMessageView: Bool = false
    @State var openMenuView: Bool = false
    @State var openMapView: Bool = false
    @State var currentUserProfileImage: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    @StateObject var retrieve = RetrievePosts()
    
    @AppStorage("user_id") var currentUserID: String?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
            ZStack(alignment: .bottomTrailing) {
            NavigationView {
                ZStack {
                    ZStack(alignment: .bottomTrailing) {
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                ZStack {
                                    HStack {
                                        Button {
                                            openMenuView.toggle()
                                        } label: {
                                            Image(uiImage: currentUserProfileImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 38, height: 38)
                                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                        }
                                        Spacer()
                                        Button {
                                            openNewPostView.toggle()
                                        } label: {
                                            Image(systemName: "paperplane")
                                                .font(.system(size: 17))
                                                .foregroundColor(Color(.label))
                                        }
                                    }
                                    Text("Lunar")
                                        .font(.system(size: 19))
                                        .fontWeight(.medium)
                                }
                                .padding(.vertical, 8)
                                .frame(width: UIScreen.main.bounds.width - 30)
                                Divider()
                                    .opacity(0.8)
                                    ScrollView(.vertical, showsIndicators: false) {
                                        VStack(spacing: 0) {
                                            ForEach(retrieve.post) { post in
                                                Post(ellipsis: $ellipsis, post: post)
                                            }
                                        }
                                    }
                            }
                            .navigationBarHidden(true)
                        }
                    }

                }
            }
            }
            .fullScreenCover(isPresented: $openNewPostView) {
                NewPostView(currentUserProfileImage: $currentUserProfileImage)
            }
            .sheet(isPresented: $openMessageView ,content: {
                MessageView()
            })
            .sheet(isPresented: $openMenuView ,content: {
                MenuView(currentUserProfileImage: $currentUserProfileImage, back: $openMenuView)
            })
            .sheet(isPresented: $openMapView ,content: {
                MapView(name: "N", title: "jnd", content: "kndknf", pfp: $currentUserProfileImage)
            })
            .sheet(isPresented: $openNotificationView ,content: {
                NotificationView()
            })
            .onAppear {
                getCurrentUserProfileImage()
                //     locationManager.checkIfLocationServicesIsEnable()
            }
    }
    
    func getCurrentUserProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: currentUserID!) { (returnedImage) in
            if let image = returnedImage {
                self.currentUserProfileImage = image
            }
        }
    }
    
    func deletePost() {
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

