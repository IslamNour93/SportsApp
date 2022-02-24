//
//  File.swift
//  Sports App
//
//  Created by Islam Noureldeen on 22/02/2022.
//

import Foundation
import UIKit

struct League{
    
    var idLeague : String?
    var strLeague : String?
    var strSport : String?
    var strLeagueAlternate : String?
    
    init(idLeg : String, strLeg: String, strSport:String,strLegAlternate:String){
        
        self.idLeague = idLeg
        self.strSport = strSport
        self.strLeagueAlternate = strLegAlternate
        self.strLeague = strLeg
    }
}

struct Sport{
    
    var idSport : String?
    var strSport : String?
    var strFormat : String?
    var strSportThumb : String?
    var strSportIconGreen : String?
    var strSportDescription : String?
    
    init(idSport : String, strSport: String, strFormat:String,strSportThumb:String,strSportIconGreen: String, strSportDescription: String){
        
        self.strSport = strSport
        self.idSport = idSport
        self.strSportThumb = strSportThumb
        self.strSportDescription = strSportDescription
        self.strSportIconGreen = strSportIconGreen
        self.strFormat = strFormat
}
}
