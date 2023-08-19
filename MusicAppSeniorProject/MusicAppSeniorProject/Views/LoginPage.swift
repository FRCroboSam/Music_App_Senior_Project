//
//  CreateTeacherProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/20/23.
//

import SwiftUI
import FirebaseAuth
struct LoginPage: View {
    @EnvironmentObject var modelData : ModelData
    @EnvironmentObject var teacherModelData: TeacherModelData
    @State private var noUserFound = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var studentLoginSuccessful = false
    @State private var teacherLoginSuccessful = false
    @State private var userType: String = "Student"
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var age: Double = 12
    @State private var selectedInstrument: String = "Cello"
    @State private var moveOn = false;
    //new navigation stack stuff
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var body: some View {
        ZStack{
            Image("music_background2")
                .resizable()
//                    .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                Text("Music Matcher Login ")
                //                    .font(.largeTitle)
                    .font(.custom("MarkerFelt-Wide", size: 50))
                    .minimumScaleFactor(0.01)
                    .frame(maxWidth: 5/6 * deviceWidth)
                    .lineLimit(1)
                    .foregroundColor(.white)
//                    .bold()
//                    .italic()
                
                Image("app_icon")
                    .resizable()
                    .aspectRatio(contentMode:.fill)
                    .padding(.bottom,-30)
                HStack(spacing: 10){
                    Text("Are you a: ")
                        .font(.custom("MarkerFelt-Wide", size: 30))
                        .foregroundColor(.white)

                    Menu {
                        Button("Student") {
                            userType = "Student  "
                        }
                        Button("Teacher") {
                            userType = "Teacher"
                        }
                    } label: {
                        Text(userType)
                            .font(.title)
                            .foregroundColor(.orange)
                    }
                }

                Spacer(minLength: 30)
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email", text: $email)
                        .foregroundColor(.white)
                        .keyboardType(.asciiCapable)
                        .autocorrectionDisabled()
                    
                }.modifier(customViewModifier(roundedCornes: 20, startColor: .orange, endColor: .pink, textColor: .white))
                    .padding(20)
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                        .textContentType(.newPassword)
                        .keyboardType(.asciiCapable)
                        .autocorrectionDisabled()

                }.modifier(customViewModifier(roundedCornes: 20, startColor: .orange, endColor: .pink, textColor: .white))
                Spacer(minLength: 50)
                Button("Sign In") {
                    print("USER TYPE IS: " + userType)
                    if(userType != "Teacher"){
                        print("SIGNING IN FOR STUDENT")
                        modelData.signinWithEmail(email: email, password: password){ isFound in
                            if isFound {
                                print("Login Successful")
                                noUserFound = false
                                studentLoginSuccessful = true
                            } else {
                                print("LoginFailed")
                                noUserFound = true
                                studentLoginSuccessful = false
                            }
                        }
                    }
                    else{
                        teacherModelData.signinWithEmail(email: email, password: password){ isFound in
                            if isFound {
                                print("LoginSuccessful")
                                noUserFound = false
                                teacherLoginSuccessful = true
                            } else {
                                print("LoginFailed")
                                noUserFound = true
                                teacherLoginSuccessful = false
                            }
                        }
                    }
                }.buttonStyle(BigButtonStyle())

                .alert("No User Found", isPresented: $noUserFound) {
                     Button("Try Again", role: .destructive) { }
                 }
                
                Spacer(minLength: 20)
            }.padding()

            .navigationDestination(isPresented: $studentLoginSuccessful) {
                StudentAppPage()
            }
            .navigationDestination(isPresented: $teacherLoginSuccessful) {
                TeacherAppPage()
            }
        }.gesture(
            TapGesture().onEnded { value in
              self.dismissKeyboard()
            })

    }
    private func dismissKeyboard() {
      UIApplication.shared.dismissKeyboard()
    }
    

}
//extension UIView{
//
// override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//     UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//
//  }
//}
extension UIApplication {
  func dismissKeyboard() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    } }
struct LoginPagePreview: PreviewProvider {
    static var previews: some View {
        LoginPage()
            .environmentObject(ModelData())
    }
}
