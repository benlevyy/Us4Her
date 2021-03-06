//
//  AddUI.swift
//  UsForHer
//
//  Created by Ben Levy on 3/5/21.
//

import SwiftUI

struct AddUI: View {
    
    @State var isPresented = true
    
    var UIState: Bool {
        return true
    } 
    
    var body: some View {
        
        if(isPresented == true){
            ZStack{
                
                Rectangle()
                    .fill(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/)
                    .frame(width: 350, height: 200)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                
                
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                HStack{
                    
                    VStack{
                        Button() {
                            isPresented = false
                        } label: {
                            Image("exit")
                                .padding(.leading, 300)
                                .padding(.bottom, 150.0)
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
    
    
}

struct AddUI_Previews: PreviewProvider {
    static var previews: some View {
        AddUI()
            .previewLayout(.fixed(width: 350, height: 200))
        
    }
}
