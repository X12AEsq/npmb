//
//  CauseLineLabel.swift
//  npmb
//
//  Created by Morris Albers on 4/10/23.
//

import SwiftUI

struct CauseLineLabel: View {
    var cause:CauseModel
    var option:Int

    var body: some View {
 
        HStack {
            if option == 1 {
                Text(cause.sortFormat1)
            } else {
                Text(cause.sortFormat2)
            }
        }
    }
}

struct CauseLineLabel_Previews: PreviewProvider {
    static var previews: some View {
        CauseLineLabel(cause: CauseModel(), option: 1)
    }
}
