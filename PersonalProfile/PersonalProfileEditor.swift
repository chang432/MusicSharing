//
//  PersonalProfileEditor.swift
//  Login_v1
//
//  Created by Jason Lo on 5/29/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct PersonalProfileEditor: View {
    @Binding var personalProfile: Profile
    @Binding var profilepic2: Image
    @State var selectedGenderIndex: Int = 0
    @State var inputImage: UIImage?
    @State var inputPic : UIImage?
    @State var image: Image?
    @EnvironmentObject var profilepicture : ProfilePicture
    
    var genderOptions = ["🙍‍♂️ Male", "🙍‍♀️ Female", "🤖 Other"]
    @State var shown = false
    
    var body: some View {
        
        VStack{
            HStack {
                VStack {

                    //Image(systemName: "person").resizable().frame(width: 60, height: 60)
                    image?.resizable().frame(width: 60, height: 60)
                    
                    Button(action: {
                        self.shown.toggle()
                    }) {
                        Text("Upload Image")
                    }.sheet(isPresented: $shown, onDismiss: {self.loadImage(); self.loadImage2(image: self.image ?? Image(systemName: "person"))}) {
                        imagePicker(shown: self.$shown, image: self.$inputImage)
                    }                }
                
                Text("Username: ").bold()
                Divider()
                TextField("Username", text: $personalProfile.username)
            }.frame(height:100)
                     
//            Button(action: {
//
//            }) {
//                Text("Upload Image")
//            }.sheet(isPresented: $shown) {
//                imagePicker(shown: self.$shown)
//            }
            
            Picker("Gender", selection: $selectedGenderIndex) {
                ForEach(0..<genderOptions.count) {
                    Text(self.genderOptions[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .onReceive([self.selectedGenderIndex].publisher.first()) { (value) in
                self.genderDecide(genderNum: value)
            }
//                .onTapGesture {
//                    self.genderDecide(genderNum: self.selectedGenderIndex)
//                    print(self.selectedGenderIndex)
//            }
            
                        
            TextField("Favorite song 1", text: $personalProfile.favsong1)
            TextField("Favorite song 2", text: $personalProfile.favsong2)
            TextField("Favorite song 3", text: $personalProfile.favsong3)
            Spacer()
        }.padding()
        
    }
    
    func genderDecide(genderNum: Int) {

        switch genderNum {
        case 0:
            personalProfile.gender = "Male"
        case 1:
            personalProfile.gender = "Female"
        case 2:
            personalProfile.gender = "Other"
        default:
            personalProfile.gender = "N/A"
        }
    }
    
    struct imagePicker : UIViewControllerRepresentable {
        //@Binding var personalProfile: Profile

        func makeCoordinator() -> imagePicker.Coordinator {
            return imagePicker.Coordinator(parent1: self)
        }
        
        @Binding var shown : Bool
        @Binding var image: UIImage?
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
            
            let imagepic = UIImagePickerController()
            imagepic.sourceType = .photoLibrary
            imagepic.delegate = context.coordinator
            return imagepic
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {

        }
        
        class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
            //@Binding var personalProfile: Profile
            @EnvironmentObject var profilepicture : ProfilePicture
            
            var parent : imagePicker!
            init(parent1 : imagePicker) {
                parent = parent1
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.shown.toggle()
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
                //let image = info[.originalImage] as! UIImage
                //parent.data = image.jpegData(compressionQuality: 0.35)!
                if let uiImage = info[.originalImage] as? UIImage {
                    parent.image = uiImage
                    //profilepicture.profilepic = uiImage
                }
//                if let uiImage = info[.originalImage] as? UIImage {
//                    profile
//                }
                
//                let storage = Storage.storage()
//                storage.reference().child("profiles/pic.jpg").putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) { (_, err) in
//                    if err != nil{
//                        print((err?.localizedDescription)!)
//                        return
//                    }
//                    print("Successfully uploaded")
//                }
                parent.shown.toggle()
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func loadImage2(image: Image) {
        self.profilepic2 = image
        print("hurray!")
    }
}


struct PersonalProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        PersonalProfileEditor(personalProfile: .constant(.default), profilepic2: .constant(Image(systemName: "star.fill"))).previewDevice("iPhone XS")
    }
}
