//
//  TXTViewer.swift
//  npmb
//
//  Created by Morris Albers on 11/23/23.
//

import SwiftUI

struct TXTViewer: View {
    var textData:String
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text(textData)
//                    ForEach(textData, id: \.self) { td in
//                        Text(td)
//                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                if textData != "" {
                    ShareLink(item:textData)
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    func txtify(txtarray:[String]) -> String {
        var rtnString:String = ""
        for txt in txtarray {
            rtnString = rtnString + txt + "\n"
        }
        return rtnString
    }
}

//#Preview {
//    TXTViewer()
//}
