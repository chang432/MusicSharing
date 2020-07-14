//
//  ContentView.swift
//  Login_v1
//
//  Created by Jason Lo on 5/23/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import MapKit
import FirebaseStorage

struct ContentView: View {
    // This is a content view
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @ObservedObject private var viewModel = ProfileViewModel()

    var body: some View {
        
        VStack{
            if status{
                Home()
            }
            else{
                Login()
            }
            
        }.animation(.spring()).onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
                
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone XS")
    }
}

struct Login: View {
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    
    var body : some View{
        
        VStack{
            
            Image("Home").resizable().frame(width: 100, height:100).clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.gray, lineWidth: 4))
            
            Text("Sign In").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom],20)
            
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    
                    HStack {
                        
                        TextField("Enter Your Username", text: $user)
                        
                        if user != "" {
                            Image("checkmark").resizable().frame(width: 25, height: 25)
                        }                     }
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    SecureField("Enter Your Password", text: $pass)
                    
                    Divider()
                }
                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        Text("Forget Password?").foregroundColor(Color.gray.opacity(0.5))
                        
                    }
                }
                
            }.padding(.horizontal, 6)
            
            Button(action: {
                signInWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    
                    if !verified {
                        self.msg = status
                        self.alert.toggle()
                    }
                    else{
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)

                    }
                }
                
            }) {
                
                Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
            }.background(Color("bg"))
                .clipShape(Capsule())
                .padding(.top, 45)
            
            bottomView()
            
        }.padding()
            .alert(isPresented: $alert) {
            
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}


struct bottomView : View {
    
    @State var show = false
    
    var body: some View{
        
        VStack{
            
//            Button(action: {
//                SpotifyAuthentication.shared.sessionManagerInitiateSession()
//
//                if let window = UIApplication.shared.windows.first {
//                    window.rootViewController = UIHostingController(rootView: AppView())
//                    window.makeKeyAndVisible()
//                }
//
//            }) {
//                Text(" Spotify ")
//                    .foregroundColor(Color.purple)
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 15, style: .continuous)
//                        .stroke(Color.purple, style: StrokeStyle(lineWidth: 2))
//                    )
//            }.padding()
            
            Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top, 20)
            
            GoogleSignView().frame(width: 150, height: 55)
            
            HStack{
                Button(action: {
                    
                }) {
                    
                    Image("google").renderingMode(.original).resizable().frame(width: 40, height: 40).padding()
                }.background(Color("white")).clipShape(Circle())
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Image("facebook").renderingMode(.original).resizable().frame(width: 40, height: 40).padding()
                }.background(Color("white")).clipShape(Circle())
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Image("linkedin").renderingMode(.original).resizable().frame(width: 40, height: 40).padding()
                }.background(Color("white")).clipShape(Circle())
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Image("twitter").renderingMode(.original).resizable().frame(width: 40, height: 40).padding()
                }.background(Color("white")).clipShape(Circle())
              
            }.padding(.top, 0)
            
            HStack(spacing: 8){
                
                Text("Dont Have An Account?").foregroundColor(Color.gray.opacity(0.5))
                
                Button(action: {
                    self.show.toggle()
                }) {
                    Text("Sign Up")
                }.foregroundColor(.blue)
                
            }.padding(.top, 20)
            
        }.sheet(isPresented: $show) {
            
            Signup(show: self.$show)
        }
    }
}

struct Signup : View {
    @State var user = ""
    @State var pass = ""
    @State var alert = false
    @State var msg = ""
    @Binding var show: Bool
    
    var body: some View {
        
        VStack {
            
            Image("Home").resizable().frame(width: 100, height:100).clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.gray, lineWidth: 4))
            
            Text("Sign Up").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom],20)
            
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    
                    HStack {
                        
                        TextField("Enter Your Username", text: $user)
                        
                        if user != "" {
                            Image("checkmark").resizable().frame(width: 25, height: 25)
                        }                     }
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    SecureField("Enter Your Password", text: $pass)
                    
                    Divider()
                }
                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        Text("Forget Password?").foregroundColor(Color.gray.opacity(0.5))
                        
                    }
                }
                
            }.padding(.horizontal, 6)
            
            Button(action: {
                signUpWithEmail(email: self.user, password: self.pass) {
                    (verified, status) in
                    
                    if !verified{
                        self.msg = status
                        self.alert.toggle()
                    }
                    else{
                        UserDefaults.standard.set(true, forKey: "status")
                        
                        self.show.toggle()
                        
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                    
                }
                
            }) {
                
                Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
            }.background(Color("bg"))
                .clipShape(Capsule())
                .padding(.top, 45)
            
        }.padding()
            .alert(isPresented: $alert) {
                
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}


struct GoogleSignView : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignView>) {
        
    }
}


func signInWithEmail(email: String, password: String, completion: @escaping(Bool,String)->Void){
    
    Auth.auth().signIn(withEmail: email, password: password) { (res,err) in
        
        if err != nil{
            completion(false,(err?.localizedDescription)!)
            return
        }
        completion(true,(res?.user.email)!)
    }
    
}

func signUpWithEmail(email: String, password: String, completion: @escaping(Bool,String)->Void){
    
    Auth.auth().createUser(withEmail: email, password: password){ (res,err) in
        
        if err != nil{
            completion(false,(err?.localizedDescription)!)
            return
        }
        completion(true,(res?.user.email)!)
    }
    
}

struct Home: View {
    @State var manager = CLLocationManager()
    @State var alert = false
    @EnvironmentObject var userData: UserData
    @State var showingProfile = false
    @ObservedObject var viewModel = ProfileViewModel()

    
    
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }
    
    var body: some View {

        NavigationView {
            
            VStack {
                  
//                Button(action: {
//                    try! Auth.auth().signOut()
//                    GIDSignIn.sharedInstance()?.signOut()
//                    UserDefaults.standard.set(false, forKey: "status")
//                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
//                }){
//                    Text("Logout")
//                }.padding(.top,10)
                
                MapView(manager: $manager, alert: $alert).alert(isPresented: $alert) {
                    
                    Alert(title: Text("Please Enable Location Access In Settings!"))
                }
                
                Button(action: {
                    SpotifyAuthentication.shared.sessionManagerInitiateSession()
                    
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: AppView())
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text(" Spotify ")
                        .foregroundColor(Color.purple)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color.purple, style: StrokeStyle(lineWidth: 2))
                        )
                }.padding()

                
//                NavigationLink(destination: AppView()) {
//                    Text(" Spotify ")
//                    .foregroundColor(Color.purple)
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 15, style: .continuous)
//                        .stroke(Color.purple, style: StrokeStyle(lineWidth: 2))
//                    )
//                }
                
                HStack{
                    
                    NavigationLink(destination: PersonalProfileHost().environmentObject(self.userData)) {
                        Image("leftarrow").renderingMode(.original).resizable().frame(width: 40, height: 30).clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.black, lineWidth: 1)).padding()
                    }
                    
                    NavigationLink(destination: ProfileListView()) {
                        Image("leftarrow").renderingMode(.original).resizable().frame(width: 40, height: 30).rotationEffect(Angle(degrees: 180)).clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.black, lineWidth: 1)).padding()
                    }
                    
                }.padding(.bottom,5)
            
                
                }
            .navigationBarTitle(Text("Home Page"),displayMode: .inline).background(Color.white)
            //.navigationBarItems(trailing: profileButton)
            .navigationBarItems(leading:
                Button(action: {
                    try! Auth.auth().signOut()
                    GIDSignIn.sharedInstance()?.signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                }){
                    Text("Logout")
                }.padding(.top,10), trailing: profileButton
            )
            .sheet(isPresented: $showingProfile) {
                PersonalProfileHost().environmentObject(self.userData)
            }
            
            
            
        }
        
    }
}


struct LeftView : View{
    var body : some View {
        Text("Left View")
    }
}

struct RightView : View{
    var body : some View {
        Text("Right View")
    }
}
struct MapView: UIViewRepresentable {
    
    @Binding var manager : CLLocationManager
    @Binding var alert: Bool
    let map = MKMapView()
    
    func makeCoordinator() -> MapView.MapCoordinator {
           return MapCoordinator(parent1: self)
       }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        
        let center = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.region = region
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        return map
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    class MapCoordinator : NSObject,CLLocationManagerDelegate{
        
        var parent : MapView
        
        init(parent1 : MapView) {
            
            parent = parent1
            
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            if status == .denied{
                parent.alert.toggle()
            }
            
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last
            let point = MKPointAnnotation()
            
            let georeader = CLGeocoder()
            georeader.reverseGeocodeLocation(location!) { (places, err) in
                
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                
                let place = places?.first?.locality
                point.title = place
                point.subtitle = "Current"
                point.coordinate = location!.coordinate
                
                self.parent.map.removeAnnotations(self.parent.map.annotations)
                self.parent.map.addAnnotation(point)
                
                let region = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.parent.map.region = region
            }
        }
    }

//    struct imagePicker : UIViewControllerRepresentable {
//        
//        func makeCoordinator() -> imagePicker.Coordinator {
//            return imagePicker.Coordinator(parent1: self)
//        }
//        
//        @Binding var shown : Bool
//        @Binding var data : Data
//        
//        func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
//            
//            let imagepic = UIImagePickerController()
//            imagepic.sourceType = .photoLibrary
//            return imagepic
//        }
//
//        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
//
//        }
//        
//        class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//            
//            var parent : imagePicker!
//            init(parent1 : imagePicker) {
//                parent = parent1
//            }
//            
//            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//                parent.shown.toggle()
//            }
//            
//            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//                let image = info[.originalImage] as! UIImage
//                parent.data = image.jpegData(compressionQuality: 0.35)!
//            }
//        }
//
//    }
    
}


