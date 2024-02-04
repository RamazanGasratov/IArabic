//
//  CustomTabBar.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: Tab
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            currentTab = tab
                        }
                    } label : {
                        Image(systemName: tab.rawValue)
                            .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currentTab == tab ? Color(.purple) : .gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(alignment: .leading) {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 56, height: 56)
                    .offset(x: 32)
                    .offset(x: indicatorOffset(with: width))
            }
        }
        .frame(height: 30)
        .padding(.bottom, 10)
        .padding([.horizontal, .top])
    }
    
    //MARK: Indicator Offset
    func indicatorOffset(with: CGFloat) -> CGFloat {
        let index = CGFloat(getIndex())
        if index == 0 {return 0}
        
        let buttonWith = with / CGFloat(Tab.allCases.count)
        
        return index * buttonWith
    }
    
    func getIndex() -> Int {
        switch currentTab {
        case .library:
            return 0
        case .wordCards:
            return 1
        case .dictionary:
            return 2
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
