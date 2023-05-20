////
////  LandmarkDetail.swift
////  TutorialProject
////
////  Created by Samuel Wang on 1/10/23.
////
//
import SwiftUI

struct TeacherProfilePage: View {
    public var teacher: Teacher
    //teacherType is if the teacher is in available teachers, requested, teachers, etc. 
    public var displayText: String
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var viewModel: ProfileModel
    var body: some View {
        let keys = teacher.teacherInfo.map{$0.key}
        let values = teacher.teacherInfo.map {$0.value}
        
        let keysMusic = teacher.musicalBackground.map{$0.key}
        let valuesMusic = teacher.musicalBackground.map{$0.value}
        
        let keysLesson = teacher.lessonInfo.map{$0.key}
        let valuesLesson = teacher.lessonInfo.map{$0.value}
        
        let name: String? = teacher.name
        let instrument: String? = teacher.instrument
        Form{
            Section{
//                EditableCircularProfileImage(viewModel: viewModel)
                HStack{
                    Text((name ?? "No Name"))
                        .font(.title)
                    
                }
                if(displayText == "Matched Teachers"){
                    Text("Contact " + teacher.name + " at " + teacher.email + " to schedule an interview!")
                }
            }
            Section {
                ForEach(keys.indices) {index in
                    HStack {
                        Text(keys[index] + ": ")
                        Text("\(values[index])")
                    }
                }
            }
            Section {
                ForEach(keysMusic.indices) {index2 in
                    HStack {
                        Text(keysMusic[index2] + ": ")
                        Text("\(valuesMusic[index2])")
                    }
                }
            }
            Section {
                ForEach(keysLesson.indices) {index3 in
                    HStack {
                        Text(keysLesson[index3] + ": ")
                        Text("\(valuesLesson[index3])")
                    }
                }
            }
            
            if(displayText == "Available Teachers"){
                Button("Decline Teacher"){
                    modelData.declineTeacher(teacherId: teacher.uid)
                }
                Button("Request Teacher"){
                    if(teacher.uid != ""){
                        modelData.requestTeacher(teacherId: teacher.uid)
                    }
                    else{
                        print("ID EMPTY")
                    }
                }
                
            }

        }
        .padding()
        .navigationTitle(name ?? "Generic Student")
        .navigationBarTitleDisplayMode(.inline)
        }
    
    }


struct TeacherProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        TeacherProfilePage(teacher: Teacher.createGenericTeacher(), displayText: "Generic")
    }
}
