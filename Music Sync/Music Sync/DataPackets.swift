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
    case timeCalibration = 0;
    case timePlaying = 1;
    case youtubeLink = 2;
    case stopMessage = 3;
}

enum DataError : Error {
    case RuntimeError(String)
}

class TimeString : Communicable {
    
    public var date : NSDate
    private static let FORMATTER : DateFormatter = getFormatter();
    
    required init (_ data: NSData) throws {
        let substring : String? = String(data: data.subdata(with: NSRange(location: 1, length: data.length - 1)),
                                         encoding: String.Encoding.utf8);
        if substring == nil {
            throw DataError.RuntimeError("TimeString Constructor Error: Malformatted Data Object: Missing Fields");
        }
        let substringU : String = substring!;
        let date : Date? = TimeString.FORMATTER.date(from: substringU);
        if date == nil {
            throw DataError.RuntimeError("TimeString Constructor Error: Unparsable Date");
        }
        self.date = (date!) as NSDate;
    }
    
    init (_ date: NSDate) {
        self.date = date;
    }
    
    func export () throws -> NSData {
        let contents : String = TimeString.FORMATTER.string(from: date as Date);
        let toReturn : Data? = contents.data(using: String.Encoding.utf8);
        if toReturn == nil {
            throw DataError.RuntimeError("TimeString Export Error: Unparsable Date");
        }
        return toReturn! as NSData;
    }
    
    private static func getFormatter () -> DateFormatter {
        let toReturn : DateFormatter = DateFormatter();
        toReturn.dateFormat = "yyyy:MM:dd:HH:mm:ss:A";
        return toReturn;
    }
}

class TimeCalibration : TimeString {
    required init (_ data: NSData) throws {
        let header : UInt8? = (data as Data).first;
        if header == nil {
            throw DataError.RuntimeError("TimeCalibration Constructor Error: Malformatted Data Object: Missing Fields");
        }
        let headerU : UInt8 = header!;
        if headerU != MessageClass.timeCalibration.rawValue {
            throw DataError.RuntimeError("TimeString Constructor Error: Invalid Data Object: Incompatible Class");
        }
        try super.init(data);
    }
    
    override init (_ date: NSDate) {
        super.init(date);
    }
    
    override func export () throws -> NSData {
        var toReturn = Data();
        let typeRep = MessageClass.timeCalibration.rawValue;
        toReturn.append(typeRep);
        toReturn.append(try super.export() as Data);
        return toReturn as NSData;
    }
}
class TimePlaying : TimeString {
    required init (_ data: NSData) throws {
        let header : UInt8? = (data as Data).first;
        if header == nil {
            throw DataError.RuntimeError("TimeCalibration Constructor Error: Malformatted Data Object: Missing Fields");
        }
        let headerU : UInt8 = header!;
        if headerU != MessageClass.timePlaying.rawValue {
            throw DataError.RuntimeError("TimeString Constructor Error: Invalid Data Object: Incompatible Class");
        }
        try super.init(data);
    }
    
    override init (_ date: NSDate) {
        super.init(date);
    }
    
    override func export () throws -> NSData {
        var toReturn = Data();
        let typeRep = MessageClass.timePlaying.rawValue;
        toReturn.append(typeRep);
        toReturn.append(try super.export() as Data);
        return toReturn as NSData;
    }
}

class YouTubeLink : Communicable {
    
    var link : String;
    
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
    
    init (_ link: String) {
        self.link = link;
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

class StopMessage : Communicable {
    required init (_ data: NSData) throws {
        let header: UInt8? = (data as Data).first;
        if header == nil {
            throw DataError.RuntimeError("StopMessage Constructor Error: Malformatted Data Object: Missing Fields");
        }
        let headerU: UInt8 = header!;
        if headerU != MessageClass.stopMessage.rawValue {
            throw DataError.RuntimeError("StopMessage Constructor Error: Invalid Data Object: Incompatible Class");
        }
    }
    init () {}
    func export () throws -> NSData {
        var toReturn: Data = Data();
        let typeRep: UInt8 = MessageClass.stopMessage.rawValue;
        toReturn.append(typeRep);
        return toReturn as NSData;
    }
}
