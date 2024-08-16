//
//  PoointRegister.swift
//  POC-Registro-Ponto
//
//  Created by Ricardo Silva Vale on 16/08/24.
//

import SwiftUI

struct PointRegister: View {
    @State private var date = Date() {
        didSet {
            updateDateInfo()
            checkAdvanceButtonState()
        }
    }
    
    @State private var dayOfWeek = ""
    @State private var formattedDate = ""
    @State private var dataInicial: Date?
    @State private var dataFinal: Date?
    @State private var totalHorasEMinutos = ""
    @State private var dataEntrada = ""
    @State private var horaEntrada = ""
    @State private var dataSaida = ""
    @State private var horaSaida = ""
    @State private var stateButton: (btEntrada: Bool, btSaida: Bool, btAvancar: Bool, stSaida: Bool) = (false, true, true, false)
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PoointRegister()
}
