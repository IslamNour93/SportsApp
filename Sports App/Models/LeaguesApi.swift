// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let leagueModel = try? newJSONDecoder().decode(LeagueModel.self, from: jsonData)

import Foundation

// MARK: - LeagueModel
struct LeagueModel: Codable {
    let countrys: [Country]?
}

// MARK: - Country
struct Country: Codable {
    let idLeague: String?
    let idSoccerXML: String?
    let idAPIfootball, strSport, strLeague, strLeagueAlternate: String?
    let intDivision, idCup, strCurrentSeason, intFormedYear: String?
    let dateFirstEvent, strGender, strCountry, strWebsite: String?
    let strFacebook: String?
    let strInstagram: String?
    let strTwitter, strYoutube, strRSS, strDescriptionEN: String?
    let strDescriptionDE, strDescriptionFR: String?
    let strDescriptionIT: String?
    let strDescriptionCN, strDescriptionJP, strDescriptionRU, strDescriptionES: String?
    let strDescriptionPT, strDescriptionSE, strDescriptionNL, strDescriptionHU: String?
    let strDescriptionNO, strDescriptionPL, strDescriptionIL, strTvRights: String?
    let strFanart1, strFanart2, strFanart3, strFanart4: String?
    let strBanner: String?
    let strBadge: String?
    let strLogo: String?
    let strPoster: String?
    let strTrophy: String?
    let strNaming: String?
    let strComplete: String?
    let strLocked: String?
}
