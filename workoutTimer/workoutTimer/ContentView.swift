//
//  ContentView.swift
//  workoutTimer
//
//  Created by Jude Willis on 27/07/2020.
//  Copyright © 2020 Jude Willis. All rights reserved.
//

import SwiftUI
import AVFoundation


var endTimerNoise : AVAudioPlayer?


class TimeHolder : ObservableObject {
    var gameTimer:Timer!
   
    @Published var elapsedTime  = 0
    @Published var roundCount  = 0
    @Published var intervalTime = ""
    @Published var noOfRounds = ""
    var isRunning = 0
    var gameTimerNo = 0
    func start(){
        if(isRunning == 0){
            elapsedTime = Int(intervalTime) ?? 0
            print(String(elapsedTime))
            roundCount = Int(noOfRounds) ?? 0
            isRunning = 1
        }
        gameTimerNo += 1
        if(gameTimerNo == 1){
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
        }
    }
    
    func stop(){
        gameTimer.invalidate()
        gameTimerNo = 0
    }
    
    func reset(){
        isRunning = 0
        gameTimerNo = 0
        elapsedTime = 0
        roundCount = 0
        noOfRounds = "0"
        intervalTime = "0"
    }
    
    @objc func addTime(){
        print("GameTimer ON")
        print(String(elapsedTime))
        elapsedTime -= 1
        
        if(elapsedTime == 0){
            let path = Bundle.main.path(forResource:"electronic_chime copy", ofType:"wav")!
            let url = URL(fileURLWithPath: path)
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
                endTimerNoise = try AVAudioPlayer(contentsOf: url)
                endTimerNoise?.play()
                print("Playing")
            } catch {
               print("Error")
            }
            roundCount -= 1
            if(roundCount == 0){
                gameTimer.invalidate()
                let path = Bundle.main.path(forResource:"metal_gong copy", ofType:"wav")!
                let url = URL(fileURLWithPath: path)
                do{
                    endTimerNoise = try AVAudioPlayer(contentsOf: url)
                    endTimerNoise?.play()
                }
                catch{
                    print("Error")
                }
                }
                else{
                elapsedTime = Int(intervalTime) ?? 0
            }
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct ContentView: View {
    @ObservedObject var durationTimer = TimeHolder()
    var body: some View {
        Button( action: {self.hideKeyboard()})
                       {
                          VStack{
                            HStack{
                                Text("Enter a time interval")
                                 .font(.system(size: 28))
                                TextField("", text: $durationTimer.intervalTime)
                                    .frame(width: 75, height: 50, alignment: .center)
                                    .keyboardType(.decimalPad)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 28))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            
                            HStack{
                                Text("Enter number of rounds")
                                    .font(.system(size: 28))
                                TextField("", text: $durationTimer.noOfRounds)
                                    .frame(width: 75, height: 50, alignment: .center)
                                    .keyboardType(.decimalPad)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 28))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                                Text("")
                                    .padding(20)
                            
                                Text("")
                                    .padding(20)
                                
                                Text(String(durationTimer.elapsedTime) + " Seconds")
                                                               .font(.system(size: 54))
                                                                .padding(10)
                                Text(String(durationTimer.roundCount) + "/" + durationTimer.noOfRounds)
                                    .font(.system(size: 30))
                                    .padding(10)
                               
                            
                            HStack{
                                Button(action: {self.durationTimer.start(); self.hideKeyboard()})
                                        {
                                            Text(" Start ")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(Color.green)
                                            .font(.system(size: 40))
                                            .cornerRadius(10)
                                        }
                                    .padding()

                                    Button(action: {self.durationTimer.stop()})
                                    {
                                        Text(" Stop ")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.red)
                                        .font(.system(size: 40))
                                        .cornerRadius(10)
                                    }
                                .padding()
                            }
                            
                            Button(action: { self.durationTimer.reset()})
                            {
                                Text(" Reset ")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.purple)
                                .font(.system(size: 40))
                                .cornerRadius(10)
                            }
                          .padding()
                                
                        }
                          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                       }
        .foregroundColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
