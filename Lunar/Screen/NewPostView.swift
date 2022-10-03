//
//  NewPostView.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/26/21.
//

import SwiftUI

struct NewPostView: View {
    
    @Binding var currentUserProfileImage: UIImage
    @State var title: String = ""
    @State var content: String = ""
    
    // DISPLAY SCREEN FORMAT
    @State var textFormat: Bool = true
    @State var voiceFormat: Bool = false
    @State var imageFormat: Bool = false
    @State var eventFormat: Bool = false
    @State var page: Int = 0
    @State private var isBack = false
    
    @StateObject var location = LocationManager()
    
    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("username") var username: String?
    @AppStorage("name") var name: String?
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var audioManager = AudioManager()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Button {
                        createPost()
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.system(size: 17))
                            .foregroundColor(.primary)
                    }
                    .opacity(title == "" && content == "" ? 0.5 : 1)
                    .disabled(title == "" && content == "" ? true : false)
                }
                Text("Create Post")
                    .font(.system(size: 19))
                    .fontWeight(.medium)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            TextFormat(title: $title, content: $content, profileImage: $currentUserProfileImage)
            //            Group {
            //                switch page {
            //                case 0:
            //                    TextFormat(title: $title, content: $content)
            //
            //                case 1:
            //                    VoiceFormat()
            //
            //                default:
            //                    FeedView()
            //                }
            //            }
            //            .transition(AnyTransition.asymmetric(
            //                insertion:.move(edge: isBack ? .leading : .trailing),
            //                removal: .move(edge: isBack ? .trailing : .leading))
            //            )
            //            .animation(.default, value: self.page)
            Spacer()
        }
    }
    
    func createPost() {
        DataService.instance.uploadPost(userID: currentUserID!, name: name!, username: username!, title: title, content: content, latitude: location.loc.latitude, longitude: location.loc.longitude) { success in
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TextFormat: View {
    @Binding var title: String
    @Binding var content: String
    @Binding var profileImage: UIImage
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Title")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color(.systemGray2))
                FirstResponder(text: $title, placeholder: "")
                    .frame(height: 30)
                Divider()
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Content")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color(.systemGray2))
                TextField("", text: $content)
                Divider()
            }
            
            HStack {
                Spacer()
                ZStack {
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(2)
                    Image(systemName: "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                        .opacity(0.9)
                }
                .padding(.top, 5)
                Spacer()
            }
        }
        .padding()
    }
}

struct VoiceFormat: View {
    @StateObject var audioManager = AudioManager()
    var body: some View {
        VStack {
            Spacer()
            HStack {
                RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                    .frame(height: 5)
                    .frame(maxWidth: .infinity)
            }
            Spacer()
            HStack {
                Button {
                    audioManager.startRecording()
                } label: {
                    Text("RECORD")
                }
                Button {
                    audioManager.stopRecording()
                } label: {
                    Text("STOP")
                }
                Button {
                    audioManager.uploadRecording()
                } label: {
                    Text("UPLOAD")
                }
            }
        }
        .padding()
    }
}

