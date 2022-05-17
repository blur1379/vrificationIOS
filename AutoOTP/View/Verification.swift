//
//  Verification.swift
//  AutoOTP
//
//  Created by mohammad blor on 4/18/22.
//

import SwiftUI

struct Verification: View {
    @StateObject var otpModel: OTPViewModel = .init()
    //MARK: TextField FocusState
    @FocusState var activField:OTPField?
    
    
    var body: some View {
        VStack{
            OTPField()
            
            Button {
                
            } label: {
                Text("verify")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical ,12)
                    .frame(maxWidth: .infinity)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.blue)
                    }
            }
            .disabled(checkStates())
            .opacity(checkStates() ? 0.4 : 1)
            .padding(.vertical)

        }
        .padding()
        .frame(maxHeight: .infinity , alignment: .top)
        .navigationTitle("Verification")
        .onChange(of: otpModel.otpField) { newValue in
            OTPCondition(value: newValue)
        }
    }
    func checkStates()->Bool{
        for index in 0..<6{
            if otpModel.otpField[index].isEmpty{return true}
        }
        return false
    }
    //MARK: Conditions For Custom OTP Field & Limiting Only one Text
    func OTPCondition(value: [String]){
        //moving next field if current field type
        for index in 0..<5{
            if value[index].count == 1 && activeStateForIndex(index: index) == activField{
                activField = activeStateForIndex(index: index + 1)
            }
        }
        // moving back if current is empty and previos is not empty
        
        for index in 1...5{
            if value[index].isEmpty && !value[index - 1].isEmpty{
                activField = activeStateForIndex(index: index - 1)
            }
        }
        
        for index in 0..<6{
            if value[index].count > 1 {
                otpModel.otpField[index] = String(value[index].last!)
            }
            
        }
    }
    //MARK: Coustom OTP TextField
    @ViewBuilder
    func OTPField()->some View{
        HStack(spacing: 14){
            ForEach(0..<6,id: \.self){index in
                VStack(spacing: 8){
                    TextField("", text: $otpModel.otpField[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activField,equals: activeStateForIndex(index: index))
                        
                    Rectangle()
                        .fill(activField == activeStateForIndex(index: index) ? .blue : .gray.opacity(0.3))
                        .frame(height: 4)
                }
            }
        }
    }
    
    func activeStateForIndex(index: Int)->OTPField{
        switch index{
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return.field6
        }
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iphone xr")
    }
}

//MARK: FocusState Enum
enum OTPField{
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}
