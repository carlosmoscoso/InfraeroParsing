//
//  InfraeroDecoder
//  Teste
//
//  Created by Carlos Alexandre Moscoso on 27/07/2018.
//  Copyright © 2018 Carlos Alexandre Moscoso. All rights reserved.
//

import Foundation

struct SOAPEnvelope: Decodable {
    var xmlBody: XMLBody
    
    enum CodingKeys: String, CodingKey {
        case xmlBody = "s:Body"
    }
}

struct XMLBody: Decodable {
    var ListarAeroportosResponse: ListarAeroportosResponse?
    var ConsultarVoosSentidoResponse: ConsultarVoosSentidoResponse?
}

struct ListarAeroportosResponse: Decodable {
    var ListarAeroportosResult: String
}

struct ConsultarVoosSentidoResponse: Decodable {
    var ConsultarVoosSentidoResult: String
}

struct ListarAeroportos: Decodable {
    var airports: [Airport]
    
    enum CodingKeys: String, CodingKey {
        case airports = "AEROPORTO"
    }
}

struct ConsultarVoos: Decodable {
    var flights: [Flight]
    
    enum CodingKeys: String, CodingKey {
        case flights = "VOO"
    }
}

struct Airport: Decodable {
    var fullName  : String
    var shortName : String
    var iataCode  : String
    var icaoCode  : String
    var region    : String
    var state     : String
    
    enum CodingKeys: String, CodingKey {
        case fullName  = "NOM_AEROPORTO"
        case shortName = "VNOM_CURTO"
        case iataCode  = "COD_IATA"
        case icaoCode  = "COD_ICAO"
        case region    = "NOM_CIDADE"
        case state     = "SIG_UF"
    }
}

struct Flight: Decodable {
    var description   : String
    var estimatedDate : String
    var estimatedTime : String
    var confirmedTime : String
    var summary       : String?
    var status        : String
    
    enum CodingKeys: String, CodingKey {
        case description   = "NUM_VOO"
        case estimatedDate = "DAT_VOO"
        case estimatedTime = "HOR_PREV"
        case confirmedTime = "HOR_CONF"
        case summary       = "NUM_GATE"
        case status        = "TXT_OBS"
    }
}

class InfraeroDecoder {
    func decode<T : Decodable>(_ type: T.Type, from data: Data) throws -> T? {
        let envelope = try? XMLDecoder().decode(SOAPEnvelope.self, from: data)
        
        var result: T? = nil
        
        if type == [Airport].self {
            
            result = try XMLDecoder()
                .decode(ListarAeroportos.self,
                        from: envelope!.xmlBody
                            .ListarAeroportosResponse!
                            .ListarAeroportosResult.data(using: .utf8)!).airports as? T
            
        } else if type == [Flight].self {
            
            result = try XMLDecoder()
                .decode(ConsultarVoos.self,
                        from: envelope!.xmlBody
                            .ConsultarVoosSentidoResponse!
                            .ConsultarVoosSentidoResult.data(using: .utf8)!).flights as? T
        }
        
        return result
    }
}
