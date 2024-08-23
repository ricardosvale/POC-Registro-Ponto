//
//  PoointRegister.swift
//  POC-Registro-Ponto
//
//  Created by Ricardo Silva Vale on 16/08/24.
//

import SwiftUI

struct PointRegister: View {
    @EnvironmentObject private var viewmodel: PointRegisterModelView
    
    var body: some View {
        VStack {
            VStack (alignment: .leading){
                //Registro de Ponto
                //Botão de Entrada
                HStack (alignment: .center){
                    Button(action: {
                        viewmodel.dataInicial = Date()
                        guard let dataInicial = viewmodel.dataInicial else { return }
                        viewmodel.dataEntrada = String(" \(viewmodel.formatDatePonto(date: dataInicial))")
                        viewmodel.horaEntrada = String(viewmodel.formatHourPonto(date: dataInicial))
                        viewmodel.stateButton.btEntrada.toggle()
                        viewmodel.stateButton.btSaida = false
                        
                   }) {
                        Rectangle()
                            .foregroundColor(viewmodel.stateButton.btEntrada ? Color.gray : Color.blue)
                            .frame(width: 90, height: 100)
                            .cornerRadius(10)
                            .overlay(
                                Image(systemName: "figure.walk.arrival")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            )
                        
                            .accessibilityLabel("Botão de Registro de Entrada")
                            .accessibilityHint(viewmodel.stateButton.btEntrada ? "Ponto de Entrada já registrado" : "Clique para registrar o ponto de entrada")
                    }
                    .accessibilityRemoveTraits(.isButton)
                    .buttonStyle(PlainButtonStyle())
                    .disabled(viewmodel.stateButton.btEntrada)
                    
                    
                    // Bloco de informações de entrada
                    
                    VStack (alignment: .leading){
                        Text(viewmodel.stateButton.btEntrada ? "Ponto de Entrada Registrado" : "Ponto de Entrada")
                            .font(.title)
                            .foregroundColor(.white)
                            .accessibilityLabel(viewmodel.stateButton.btEntrada ? "Status do Ponto de Entrada: Registrado" : "Status do Ponto de Entrada: Não Registrado")
                            .accessibilityRemoveTraits(.isStaticText)
                        
                        HStack{
                            Label("-", systemImage: "calendar")
                                .font(.title)
                                .foregroundColor(viewmodel.stateButton.btEntrada ? Color.white : Color.blue)
                            Text(viewmodel.dataEntrada)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.ultraLight)
                            Label("-", systemImage: "clock")
                                .font(.title3)
                                .foregroundColor(viewmodel.stateButton.btEntrada ? Color.white : Color.blue)
                            Text(viewmodel.horaEntrada)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.ultraLight)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Informações de Entrada")
                        .accessibilityValue("Data: \(viewmodel.dataEntrada), Hora: \(viewmodel.horaEntrada)")
                        .accessibilityRemoveTraits(.isStaticText)
                    }
                    .padding()
                    .background(viewmodel.stateButton.btEntrada ? Color.gray : Color.blue)
                    .opacity(viewmodel.stateButton.btEntrada ? 0.8 : 1.0)
                    .cornerRadius(10)
                    .padding()
                }
                .padding(.leading, 40)
                // Bater Ponto de Saída
                //Botão de Saída
                HStack{
                    
                    Button(action: {
                                viewmodel.dataFinal = Date()
                                guard let dataFinal = viewmodel.dataFinal else { return }
                                viewmodel.dataSaida = String("\(viewmodel.formatDatePonto(date: dataFinal))")
                                viewmodel.horaSaida = String(viewmodel.formatHourPonto(date: dataFinal))
                                viewmodel.stateButton.btSaida.toggle()
                                viewmodel.totalHorasEMinutos = viewmodel.calculateTimeDifference(start: viewmodel.dataInicial!, end: dataFinal)
                                viewmodel.stateButton.stSaida = true
                   }) {
                        Rectangle()
                            .foregroundColor(viewmodel.stateButton.btSaida ? Color.gray : Color.blue )
                            .frame(width: 90, height: 100)
                            .cornerRadius(10)
                            .overlay(
                                Image( systemName:"figure.walk.departure")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            )
                            .accessibilityLabel(viewmodel.stateButton.btSaida ? "Botão de Registro de Saída" : "Botão de Registro de Saída")
                            .accessibilityHint(viewmodel.stateButton.btSaida ? "" : "Clique para registrar o ponto de saída")
                    }
                    .accessibilityRemoveTraits(.isButton)
                    .buttonStyle(PlainButtonStyle())
                    .disabled(viewmodel.stateButton.btSaida)
                    
                    // Bloco de informações de saida
                    
                    VStack (alignment: .leading){
                        Text(viewmodel.stateButton.stSaida ? "Ponto de Saída Registrado" : "Ponto de Saída" )
                            .font(.title)
                            .foregroundColor(.white)
                            .accessibilityLabel(viewmodel.stateButton.stSaida ? "Status do Ponto de Saída: Registrado " : "Status do Ponto de Saída: Não Registrado")
                            .accessibilityRemoveTraits(.isStaticText)
                        
                        HStack{
                            Label("-", systemImage: "calendar")
                                .font(.title)
                                .foregroundColor(viewmodel.stateButton.btSaida ? Color.white : Color.blue)
                            Text(viewmodel.dataSaida)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.ultraLight)
                            Label("-", systemImage: "clock")
                                .font(.title3)
                                .foregroundColor(viewmodel.stateButton.btSaida ? Color.white : Color.blue)
                            Text(viewmodel.horaSaida)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.ultraLight)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Informações de Saída")
                        .accessibilityValue("Data: \(viewmodel.dataSaida), Hora: \(viewmodel.horaSaida)")
                        .accessibilityRemoveTraits(.isStaticText)
                        
                    }
                    .padding()
                    .background(viewmodel.stateButton.btSaida ? Color.gray : Color.blue)
                    .opacity(viewmodel.stateButton.btSaida ? 0.8 : 1.0)
                    .cornerRadius(10)
                    .padding()
                }
                .padding([.leading, .trailing], 40)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
            VStack (alignment: .leading) {
                Text("Total de Horas: \(viewmodel.totalHorasEMinutos)")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding([.leading, .trailing], 40)
                    .padding(.bottom, 20)
                    .accessibilityLabel("Total de Horas Trabalhadas")
                    .accessibilityValue("\(viewmodel.totalHorasEMinutos)")
                    .accessibilityRemoveTraits(.isStaticText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,  alignment: .leading)
       
              
        }.background(.white)
            .accessibilityElement(children: .contain)
    }
    
}


