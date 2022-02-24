//
//  Leagues.swift
//  Sports App
//
//  Created by Islam Noureldeen on 22/02/2022.
//

import Foundation

struct Leagues : Codable {
    let leagues : [LeagueApi]?

    enum CodingKeys: String, CodingKey {

        case leagues = "leagues"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        leagues = try values.decodeIfPresent([LeagueApi].self, forKey: .leagues)
    }

}

struct LeagueApi : Codable {
    var idLeague : String?
    var strLeague : String?
    var strSport : String?
    var strLeagueAlternate : String?

    enum CodingKeys: String, CodingKey {

        case idLeague = "idLeague"
        case strLeague = "strLeague"
        case strSport = "strSport"
        case strLeagueAlternate = "strLeagueAlternate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idLeague = try values.decodeIfPresent(String.self, forKey: .idLeague)
        strLeague = try values.decodeIfPresent(String.self, forKey: .strLeague)
        strSport = try values.decodeIfPresent(String.self, forKey: .strSport)
        strLeagueAlternate = try values.decodeIfPresent(String.self, forKey: .strLeagueAlternate)
    }

}
