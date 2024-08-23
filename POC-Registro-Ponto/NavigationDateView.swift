//
//  NavigationDateView.swift
//  POC-Registro-Ponto
//
//  Created by Ricardo Silva Vale on 22/08/24.
//

import SwiftUI

struct NavigationDateView: View {
    @StateObject private var viewModel = PointRegisterModelView()
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
       
        VStack {
            NavigationDate(
                date: $viewModel.date,
                dayOfWeek: viewModel.dayOfWeek,
                formattedDate: viewModel.formattedDate,
                onPreviousDate: {
                    guard let previousDate =
                            Calendar.current.date(
                                byAdding: .day,
                                value: -1,
                                to: viewModel.date) else { return }
                    viewModel.date = previousDate
                    
                    viewModel.stateButton.btAvancar = false
                },
                onNextDate: {
                    if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: viewModel.date), nextDate <= Date() {
                        viewModel.date = nextDate
                    }
                },
                isAdvanceButtonEnabled: !viewModel.stateButton.btAvancar
            )
            
            
            VStack (alignment: .leading){
                //Registro de Ponto
        PointRegister()
                    .environmentObject(viewModel)
          
            }
            
            .padding([.leading, .trailing], 16)
            
            Spacer()
                .onAppear {
                    viewModel.updateDateInfo()
                    viewModel.checkAdvanceButtonState()
                }
            
                .onReceive(timer) { _ in
                    viewModel.updateTimeOnly()
                    
                }
            
        }.background(.white)
    }
}
