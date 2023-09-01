//
//  TeacherListView.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 6/19/23.
//

import SwiftUI
import SDWebImageSwiftUI
enum teacherType{
    case AVAILABLE, REQUESTED, DECLINED, MATCHED
}
struct TeacherListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var modelData: ModelData
    @Binding var displayArray: [Teacher]
    @Binding var uiImage: UIImage?
    let status: String
    let displayText: String
    @State private var loggedOut = false
    @State private var showInfo  = false
    @State private var searchTeacher = ""
    @State private var listHeight = 500.0
    @State private var offset: Double = 0.0

    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                    Spacer()
                        .frame(height: 1/10 * deviceHeight)
                    GeometryReader{ geometry in
                        ZStack{
                            VStack(alignment: .center, spacing: 10){
                                Section{
                                    //TODO: REIMPLEMENT IMAGE STRUCTURE TO USE WEBIMAGE
                                    ProfileImage(image: Image(uiImage:(uiImage ?? UIImage(systemName: "person.fill"))!), size: 100)
                                        .overlay(Circle()
                                            .strokeBorder(Color.white,lineWidth: 5)
                                        ).modifier(CenterModifier())

                                    Spacer()
                                        .frame(height: 10)
                                    HStack{
                                        Text(" " + status + " ")
                                            .lineLimit(1)
                                            .font(.custom("MarkerFelt-Wide", size: 40))
                                            .foregroundColor(.white)
                                            .minimumScaleFactor(0.01)

                                            .background(Color.teal)
                                            .clipShape(RoundedRectangle(cornerRadius:10))
                                            .overlay(alignment: .topTrailing){
                                                Button{
                                                    showInfo.toggle()
                                                }label:{
                                                    Image(systemName: "info.circle")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .background {
                                                            Circle().fill(
                                                                Color.white
                                                            )
                                                        }
                                                }.offset(x: 2, y: -15)
                                            }


                                    }//.modifier(CenterModifier())
                                }
                            }
                        }
                    }.frame(maxHeight: 1/5 * deviceHeight)
                    .onTapGesture {
                        showInfo = false
                    }
                    .background{
                        Image("music_background")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .aspectRatio(contentMode: .fill)
                    }

                
                Spacer()
                    .frame(height: 1/30 * deviceHeight)
                ZStack{
                    VStack(spacing: 0){
//                        Section{
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                                TextField("Enter a teacher name", text: $searchTeacher)
                                    .foregroundColor(.white)
                                    .textContentType(.newPassword)
                                    .keyboardType(.asciiCapable)
                                    .autocorrectionDisabled()
                                    .listRowSeparator(.hidden)
                                
                                
                            }.modifier(customViewModifier(roundedCornes: 30, startColor: .orange, endColor: .green, textColor: .black, ratio: 0.925))
                                .padding(.top, 10)
                                .offset(y: 20)
                            
                            //TODO: TRY EMBEDDING THE LIST IN A ZSTACK THAT WAY YOU CAN USE THE FRAME THING AND ITLL ONLY AFFECT THE LIST
                            //make the offset however big divider offset is and frame big enough to cover between divider and search
                            Rectangle()
                            .offset(y:20)
                                .frame(maxHeight: 30)
                                .foregroundColor(Color.white)
                                .zIndex(4)
                            Divider()
                            .offset(y:20)
                                .zIndex(6)
//                        }
                        ScrollViewReader{ proxy in
                            List{
                                Section{
                                    ForEach(Array(displayArray.enumerated()), id: \.element.id) { index, teacher in
                                        if(teacher.name.contains(searchTeacher) || searchTeacher == ""){
                                            NavigationLink{
                                                ProfilePageUI(teacher: teacher)
                                            } label:{
                                                HStack{
                                                    //                                            WebImage(url: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/musicapp-52b7f.appspot.com/o/jOH4EANrxIfRiN1e4XCYLeg1HY03?alt=media&token=3560fe33-6c4c-4941-a4b6-721b4789f15c"))
                                                    //                                                .resizable()
                                                    //                                                .font(.system(size: 40))
                                                    //                                                .scaledToFill()
                                                    //                                                .clipShape(Circle())
                                                    //                                                .frame(width: 50, height: 50)
                                                    if(teacher.imageURL.count > 2){
                                                        ProfileImageFromURL(url: teacher.imageURL)
                                                    }
                                                    else{
                                                        ProfileImage(image: Image(uiImage: (teacher.uiImage ?? UIImage(systemName: "person.fill"))!), size: 50)
                                                    }
                                                    VStack(alignment: .leading) {
                                                        Spacer()
                                                        Text(teacher.name).font(.system(size: 25))
                                                        Text(teacher.instrument).font(.subheadline)
                                                    }.foregroundColor(.black)
                                                }
                                                .buttonStyle(BigButtonStyle())
                                                .swipeActions {
                                                    Button("Decline") {
                                                        print("Awesome!")
                                                    }
                                                    .tint(.red)
                                                }
                                            }.id(index)
                                        }
                                    } .onMove { from, to in
                                        
                                        displayArray.move(fromOffsets: from, toOffset: to)
                                    }
                                    
                                } //header: {
                                //                                Text(displayText)
                                //                                    .font(.system(size: 20))
                                //                                    .textCase(.none)
                                //                            }
                                .listSectionSeparator(.hidden, edges: .top)
                                HStack{
                                    Button("Log Out"){
    
//                                        modelData.logOut()
//                                        loggedOut = true
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                            modelData.reset()
                                       //}
                                    }
                                    .modifier(CenterModifier())
                                    .buttonStyle(FillButtonStyle(color: .red))
                                }
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowSeparator(.hidden)
                            }
                            .edgesIgnoringSafeArea(.all)
                            .listStyle(GroupedListStyle())
                            .scrollContentBackground(.hidden)
                            Spacer()
                                .ignoresSafeArea(.all)
                                .frame(height: 30)
                                .listRowSeparator(.hidden)
                            
                                .navigationDestination(isPresented: $loggedOut, destination: {
                                    HomePage()
                                })
                                .onAppear{
                                    proxy.scrollTo(4)
                                }
                        }
                        .zIndex(2)
                    }
                    
                    .background{
                        Color.white
                    }.cornerRadius(20)
                        .frame(width: deviceWidth, height: 2/3 * deviceHeight)
                        .contentShape(Rectangle())
                        .zIndex(3)
                    
                }

            }
        }
    }
//struct TeacherListView_Previews: PreviewProvider {
//    static var previews: some View {
////        TeacherListView()
//    }
}
struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}



