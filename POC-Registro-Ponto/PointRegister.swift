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
        VStack (alignment: .center){
            HStack (alignment: .center) {
                Button(action: {
                    if let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date) {
                        let calendar = Calendar.current
                        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: previousDate)
                        components.hour = calendar.component(.hour, from: date)
                        components.minute = calendar.component(.minute, from: date)
                        components.second = calendar.component(.second, from: date)
                        date = calendar.date(from: components) ?? date
                    }
                    stateButton.btAvancar = false
                }) {
                    Image( systemName: "chevron.left")
                        .padding(.leading, 70)
                        .font(.system(size: 50, weight: .semibold))
                        .foregroundColor(.blue)
                        .background(.white)
                        .frame(width: 40, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                VStack (alignment: .center) {
                    Text(dayOfWeek.capitalized)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                        .foregroundColor(.black)
                    
                    
                    Text(formattedDate)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.leading, 30)
                }
                
                Spacer()
                
                Button(action: {
                    if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date), nextDate <= Date() {
                        date = nextDate
                    }
                }) {
                    Image( systemName: "chevron.right")
                        .font(.system(size: 50, weight: .semibold))
                        .foregroundColor(.blue)
                        .frame(width: 40, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(stateButton.btAvancar)
                
                Spacer()
            }
            .padding(.top, 50)
            
            VStack {
                HStack {
                    Button(action: {
                        dataInicial = Date()
                        guard let dataInicial = dataInicial else { return }
                        dataEntrada = String(" \(formatDatePonto(date: dataInicial))")
                        horaEntrada = String(formatHourPonto(date: dataInicial))
                        stateButton.btEntrada.toggle()
                        stateButton.btSaida = false
                    }) {
                        Image( systemName: "figure.walk.departure")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                            .background(stateButton.btEntrada ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(stateButton.btEntrada)
                    .padding(.trailing, 30)
                    
                    
                    VStack (alignment: .leading){
                        Text(stateButton.btEntrada ? "Ponto de Entrada Registrado"  : "Ponto de Entrada")
                            .foregroundColor(.black)
                            .font(.title)
                        HStack {
                            Label("-", systemImage: "calendar")
                                .foregroundColor(.blue)
                            Text(dataEntrada)
                                .foregroundColor(.black)
                            Label("-", systemImage: "clock")
                                .foregroundColor(.blue)
                            Text(horaEntrada)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                HStack {
                    Button(action: {
                        dataFinal = Date()
                        guard let dataFinal = dataFinal else { return }
                        dataSaida = String("\(formatDatePonto(date: dataFinal))")
                        horaSaida = String(formatHourPonto(date: dataFinal))
                        stateButton.btSaida.toggle()
                        totalHorasEMinutos = calculateTimeDifference(start: dataInicial!, end: dataFinal)
                        stateButton.stSaida = true
                    }) {
                        Image(systemName: "figure.walk.arrival")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                            .background(stateButton.btSaida ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(stateButton.btSaida)
                    .padding(.trailing, 30)
                    
                    VStack (alignment: .leading){
                        Text(stateButton.stSaida ? "Ponto de Saída Registrado" : "Ponto de Saída")
                            .foregroundColor(.black)
                            .font(.title)
                        HStack {
                            Label("-", systemImage: "calendar")
                                .foregroundColor(.blue)
                            Text(dataSaida)
                                .foregroundColor(.black)
                            Label("-", systemImage: "clock")
                                .foregroundColor(.blue)
                            Text(horaSaida)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Text("Total de horas: \(totalHorasEMinutos).")
                    .font(.title2)
                    .foregroundColor(.black)
                Spacer()
                
                
            }
            .padding()
            .frame(height: 300)
            
        }
        .onAppear {
            updateDateInfo()
            checkAdvanceButtonState() // Verifica o estado do botão ao aparecer
        }
        .onReceive(timer) { _ in
            updateTimeOnly()
        }
        .background(.white)
    }
    
    
    /// Essa função atualiza somente o horário sem alterar a data.
    ///
    ///Atualiza somente o horário, podendo atualizar a data sem alterar a hora atual.
    ///
    ///```swift
    ///let calendar = Calendar.current
    ///var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    ///let currentTime = Date()
    /// components.hour = calendar.component(.hour, from: currentTime)
    ///components.minute = calendar.component(.minute, from: currentTime)
    ///components.second = calendar.component(.second, from: currentTime)
    ///date = calendar.date(from: components) ?? date
    ///
    ///```
    /// - Returns: Não retorna nada
    func updateTimeOnly() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let currentTime = Date()
        components.hour = calendar.component(.hour, from: currentTime)
        components.minute = calendar.component(.minute, from: currentTime)
        components.second = calendar.component(.second, from: currentTime)
        date = calendar.date(from: components) ?? date
    }
    
    
    func updateDateInfo() {
        dayOfWeek = getDayOfWeek(date: date)
        formattedDate = formatDate(date: date)
    }
    
    func checkAdvanceButtonState() {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let displayedDate = calendar.startOfDay(for: date)
        
        // Atualiza o estado do botão com base na comparação das datas
        stateButton.btAvancar = displayedDate == currentDate
    }
    
    func getDayOfWeek(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    func formatDatePonto(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateStyle = .full
        dateFormatter.dateFormat = "EEE dd 'de' MMMM"
        return dateFormatter.string(from: date)
    }
    
    func formatHourPonto(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func calculateTimeDifference(start: Date, end: Date) -> String {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        let hours = difference.hour ?? 0
        let minutes = difference.minute ?? 0
        return "\(hours) horas e \(minutes) minutos"
    }
}


#Preview {
    PointRegister()
}
