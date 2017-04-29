//
//  DataPackets.swift
//  Music Sync
//
//  Created by David Mrdjenovich on 4/28/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import Foundation

protocol Communicable {
    init (_ : NSData) throws;
    func export () throws -> NSData;
}

enum MessageClass : UInt8 {
    case timeString = 0
    case youtubeLink = 1
}

enum DataError : Error {
    case RuntimeError(String)
}

class TimeString : Communicable {
    
    private var date : NSDate
    private static let FORMATTER : DateFormatter = getFormatter();
    
    required init (_ data: NSData) throws {
        let header : UInt8? = (data as Data).first;
        let substring : String? = String(data: data.subdata(with: NSRange(location: 1, length: data.length - 1)),
                                         encoding: String.Encoding.utf8);
        if header == nil || substring == nil {
            throw DataError.RuntimeError("TimeString Constructor Error: Malformatted Data Object: Missing Fields");
        }
        let headerU : UInt8 = header!;
        let substringU : String = substring!;
        if headerU != MessageClass.timeString.rawValue {
            throw DataError.RuntimeError("TimeString Constructor Error: Invalid Data Object: Incompatible Class");
        }
        let date : Date? = TimeString.FORMATTER.date(from: substringU);
        if date == nil {
            throw DataError.RuntimeError("TimeString Constructor Error: Unparsable Date");
        }
        self.date = (date!) as NSDate;
    }
    
    func export () throws -> NSData {
        var toReturn = Data();
        let typeRep = MessageClass.timeString.rawValue;
        toReturn.append(typeRep);
        let contents : String = TimeString.FORMATTER.string(from: date as Date);
        let toAppend : Data? = contents.data(using: String.Encoding.utf8);
        if toAppend == nil {
            throw DataError.RuntimeError("TimeString Export Error: Unparsable Date");
        }
        toReturn.append(toAppend!);
        return toReturn as NSData;
    }
    
    private static func getFormatter () -> DateFormatter {
        let toReturn : DateFormatter = DateFormatter();
        toReturn.dateFormat = "yyyy:MM:dd:HH:mm:ss:A";
        return toReturn;
    }
}

class YouTubeLink : Communicable {
    
    private var link : String;
    
    required init (_ data: NSData) throws {
        let header : UInt8? = (data as Data).first;
        let substring : String? = String(data: data.subdata(with: NSRange(location: 1, length: data.length - 1)),
                                         encoding: String.Encoding.utf8);
        if header == nil || substring == nil {
            throw DataError.RuntimeError("TimeString Constructor Error: Malformatted Data Object: Missing Fields");
        }
        let headerU : UInt8 = header!;
        let substringU : String = substring!;
        if headerU != MessageClass.youtubeLink.rawValue {
            throw DataError.RuntimeError("YouTubeLink Constructor Error: Invalid Data Object: Incompatible Class");
        }
        link = substringU;
    }
    
    func export () throws -> NSData {
        var toReturn : Data = Data();
        let typeRep : UInt8 = MessageClass.youtubeLink.rawValue;
        toReturn.append(typeRep);
        let toAppend : Data? = link.data(using: String.Encoding.utf8);
        if toAppend == nil {
            throw DataError.RuntimeError("YouTubeLink Export Error: Unparsable Data");
        }
        toReturn.append(toAppend!);
        return toReturn as NSData;
    }
}
