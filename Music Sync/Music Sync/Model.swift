//
//  Model.swift
//  Music Sync
//
//  Created by David Mrdjenovich on 4/28/17.
//  Copyright © 2017 Brandon Pearl. All rights reserved.
//

import Foundation;
import MultipeerConnectivity;

enum MultipeerError : Error {
    case RuntimeError(String)
}

class Networker : NSObject {
    
    let peerID : MCPeerID;
    var serviceAdvertiser : MCNearbyServiceAdvertiser;
    var serviceBrowser : MCNearbyServiceBrowser;
    var baseSession : MCSession;
    
    var baseVC : ViewControllerBase;
    
    let serviceType : String = "music-sync";
    
    init (_ displayName: String, _ discoveryInfo: [String:String], _ baseVC: ViewControllerBase) {
        self.baseVC = baseVC;
        peerID = MCPeerID(displayName: displayName);
        serviceAdvertiser = MCNearbyServiceAdvertiser(
            peer: peerID,
            discoveryInfo: discoveryInfo,
            serviceType: serviceType);
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType);
        baseSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none);
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer();
        serviceBrowser.stopBrowsingForPeers();
        baseSession.disconnect();
    }
    
    func startDiscovery () -> Void {
        serviceAdvertiser.startAdvertisingPeer();
        serviceBrowser.startBrowsingForPeers();
    }
    
    func endDiscovery () -> Void {
        serviceAdvertiser.stopAdvertisingPeer();
        serviceBrowser.stopBrowsingForPeers();
    }
    
    func throwError (_ message: String) -> Void {
        NSLog(message);
    }
    
}

class Host : Networker, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {

    var discoveredGuests : Array<MCPeerID> = Array<MCPeerID>();
    var finalGuests : Array<MCPeerID> = Array<MCPeerID>();
    
    //Time Calibration Data: Array Entries correspond to guests in order of final/discovered guests.
    private var calibrationPointer: Int = 0;
    private var calibrationQueries: Array<NSDate> = [];         //Initial times sent to guests.
    private var calibrationResponses: Array<NSDate> = [];       //Time at which we received guest response.
    private var calibrationContent: Array<NSDate> = [];         //Guest's clock response.
    private var calibrationDeltas: Array<TimeInterval> = [];    //Final calculated guest clock deltas.
    private var calibrationFinalized: Bool = false;
    
    var youTubeLink : String? = nil;
    var youTubePlayTime : NSDate? = nil;
    
    var cDelays: Array<TimeInterval> = [];
    
    
    init (displayName : String, baseVC: ViewControllerBase) {
        super.init(displayName, ["ID":"HOST"], baseVC);
        serviceAdvertiser.delegate = self;
        serviceBrowser.delegate = self;
        baseSession.delegate = self;
        startDiscovery();
    }
    
    /* Discover Guests */
    //MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        baseVC.throwError("Error: Could not start MCNearbyServiceAdvertiser");
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        baseVC.throwError("Error: Host cannot respond to invitations");
    }
    //MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error) {
        baseVC.throwError("Error: Could not start MCNearbyServiceBrowser");
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        do {
            if info!["ID"] == "HOST" {return;}
            discoveredGuests.append(peerID);
            OperationQueue.main.addOperation {
                (self.baseVC as! HostConnectionViewController).tableUpdated();
            }
        }
        catch is NSError {
            baseVC.throwError("Invalid Guest Detected: Missing discovery info.");
        }
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        for i in 0..<discoveredGuests.count {
            if discoveredGuests[i].isEqual(peerID) {
                discoveredGuests.remove(at: i);
                OperationQueue.main.addOperation {
                    (self.baseVC as! HostConnectionViewController).tableUpdated();
                }
            }
        }
    }
    
    /* Invite Guests */
    func sendInvitations (toGuests guests: Array<MCPeerID>) {
        for peer in guests {
            serviceBrowser.invitePeer(peer, to: baseSession, withContext: nil, timeout: 300);
            NSLog("\n\nInvited Peer\n\n");
        }
    }
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        
        NSLog("\n\nDetected Change In PeerSessionState \(peerID.displayName) \(state.rawValue)\t\(MCSessionState.connected.rawValue),\(MCSessionState.connecting.rawValue),\(MCSessionState.notConnected.rawValue)\n\n");
        
        if state == MCSessionState.connected {
            finalGuests.append(peerID);
            cDelays.append(0);
        }
        else if state == MCSessionState.notConnected {
            for i in 0..<finalGuests.count {
                if finalGuests[i].isEqual(peerID) {
                    finalGuests.remove(at: i);
                    cDelays.remove(at: i);
                    if baseVC is ConfigureViewController {
                        OperationQueue.main.addOperation {
                            (self.baseVC as! ConfigureViewController).dropEvent();
                        }
                    }
                    if calibrationPointer > i {
                        calibrationQueries.remove(at: i);
                        calibrationResponses.remove(at: i);
                        calibrationContent.remove(at: i);
                        calibrationDeltas.remove(at: i);
                        calibrationPointer -= 1;
                    }
                }
            }
        }
        if baseVC is HostConnectionViewController {
            OperationQueue.main.addOperation {
                (self.baseVC as! HostConnectionViewController).tableUpdated();
            }
        }
    }
    
    /* Comunicate with Guests */
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID) {
        if data.first == nil {
            baseVC.throwError("Host received invalid Data object in session.");
        }
        else if data.first! == MessageClass.timeCalibration.rawValue {
            //Time string received from guest in response to getTimeDelays() initial call.
            do {
                let received: TimeCalibration = try TimeCalibration(data as NSData);
                calibrationResponses.append(NSDate());
                calibrationContent.append(received.date);
                if calibrationPointer < finalGuests.count - 1 {
                    calibrationPointer += 1;
                    let toSend: NSDate = NSDate();
                    calibrationQueries.append(toSend);
                    try baseSession.send(TimeCalibration(toSend).export() as Data, toPeers: [finalGuests[calibrationPointer]], with: MCSessionSendDataMode.reliable);
                }
                else {
                    calibrationPointer += 1;
                    calibrationFinalized = true;
                    finalizeDeltas();
                }
            }
            catch is NSError {
                baseVC.throwError("Error Decoding TimeCalibration Data Packet");
            }
        }
        else if data.first! == MessageClass.youtubeLink.rawValue {
            //YouTubeLink data received from guests.
            //  ... should never occur.
            baseVC.throwError("Received youtube link from guests - Unexpected Data");
        }
        else if data.first! == MessageClass.timePlaying.rawValue {
            //TimeToPlay data received from guests.
            //  ... should never occur.
            baseVC.throwError("Received TimeToPlay data from guests - Unexpected Data");
        }
        else if data.first! == MessageClass.stopMessage.rawValue {
            //StopMessage data received from guests.
            //  ... shoudl never occur.
            baseVC.throwError("Received StopMessage from guests - Unexpected Data");
        }
    }
    /** 
     * Initiates the time calibration process.
     *      Sends time data to first guest, initiating a chain reaction in which all guests
     *      are eventually contacted and their ping times recorded.
     */
    func getTimeDelays () {
        calibrationPointer = 0;
        calibrationFinalized = false;
        calibrationQueries = [];
        calibrationContent = [];
        calibrationResponses = [];
        calibrationDeltas = [];
        do {
            let toSend: NSDate = NSDate();
            calibrationQueries.append(toSend);
            try baseSession.send(TimeCalibration(toSend).export() as Data, toPeers: [finalGuests[0]], with: MCSessionSendDataMode.reliable);
        }
        catch is NSError {
            baseVC.throwError("Error Sending Time Calibrations.");
        }
    }
    private func finalizeDeltas () {
        for i in 0..<finalGuests.count {
            let ping: TimeInterval = calibrationResponses[i].timeIntervalSince(calibrationQueries[i] as Date)/2;
            calibrationDeltas.append(calibrationContent[i].timeIntervalSince(calibrationQueries[i] as Date) - ping);
        }
    }
    /**
     * Sends the youtube video address to all guests.
     */
    func sendYouTubeAddress (_ toSend: String) {
        do {
            youTubeLink = toSend;
            try baseSession.send(YouTubeLink(toSend).export() as Data, toPeers: finalGuests, with: MCSessionSendDataMode.reliable);
        }
        catch is NSError {
            baseVC.throwError("Error Sending YouTubeAddress Object");
        }
    }
    /**
     * Returns the mininmum delay required to synchronize the playing of a YouTube video
     * as a function of maximum ping time among devices.
     */
    func getMinDelay () -> TimeInterval {
        var sum: Double = 0;
        for i in 0..<finalGuests.count {
            sum += calibrationDeltas[i]*1.2*2;
        }
        return sum;
    }
    /**
     * Sets the time delay for a given MCPeer object appearing in finalGuests.
     */
    func setCDelay (_ peer: MCPeerID, _ newValue: TimeInterval) {
        var found : Int? = nil;
        for i in 0..<finalGuests.count {
            if finalGuests[i].isEqual(peer) {
                found = i; break;
            }
        }
        if (found == nil) { baseVC.throwError("Setting time delay for guest not in session"); }
        else { cDelays[found!] = newValue; }
    }
    /**
     * Sends corrected play times to each guest.
     * Through this method, guests receive the time at which to play the YouTube Video.
     * Guests are then expected to play the YouTube video at the specified time.
     */
    func sendPlayTimes (_ globalDelay: TimeInterval) {
        let globalDelay = getMinDelay();
        for i in 0..<finalGuests.count {
            do {
                try baseSession.send(TimePlaying(NSDate().addingTimeInterval(calibrationDeltas[i]+globalDelay+cDelays[i])).export() as Data, toPeers: [finalGuests[i]], with: MCSessionSendDataMode.reliable);
            }
            catch is NSError {
                baseVC.throwError("Error Sending Play Times");
            }
        }
    }
    /**
     * Sends the stop message to all guests.
     */
    func stopGuests () {
        do {
            try baseSession.send(StopMessage().export() as Data, toPeers: finalGuests, with: MCSessionSendDataMode.reliable);
        }
        catch is NSError {
            baseVC.throwError("Error Sending StopMessage Object");
        }
    }
    
    
    
    
    
    //Unused Delegate Methods
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {
    }
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL,
                 withError error: Error?) {
    }
    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {
    }
    /*
    func session(_ session: MCSession,
                 didReceiveCertificate certificate: [Any]?,
                 fromPeer peerID: MCPeerID,
                 certificateHandler: @escaping (Bool) -> Void) {
    }
    */
    
}

class Guest : Networker, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    var invitingHosts : Array<MCPeerID> = Array<MCPeerID>();
    var invitationHandlers : Array<(Bool, MCSession?) -> Void> = Array<(Bool, MCSession?) -> Void>();
    
    var chosenHost : MCPeerID? = nil;
    
    var youTubeLink : String? = nil;
    var youTubePlayTime : NSDate? = nil;
    
    init (displayName : String, baseVC: ViewControllerBase) {
        super.init(displayName, ["ID":"GUEST"], baseVC);
        serviceAdvertiser.delegate = self;
        serviceBrowser.delegate = self;
        baseSession.delegate = self;
        startDiscovery();
    }
    
    /* Become Discoverable */
    //MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        baseVC.throwError("Error: Could not start MCNearbyServiceAdvertiser");
    }
    
    /* Receive Invitations */
    //MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitingHosts.append(peerID);
        invitationHandlers.append(invitationHandler);
        (baseVC as! GuestConnectionViewController).tableUpdated();
    }
    
    //MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error) {
        baseVC.throwError("Error: Could not start MCNearbyServiceBrowser");
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        //Do Nothing
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        //Do Nothing
    }
    
    /* Accept one invitation */
    func acceptInvitation (peerID: MCPeerID) {
        chosenHost = peerID;
        var loc : Int = -1;
        for i in 0..<invitingHosts.count {
            if invitingHosts[i].isEqual(peerID) {
                loc = i;
            }
        }
        if loc == -1 { baseVC.throwError("Error: Did not receive invitation from indicated host"); }
        else {
            for i in 0..<invitingHosts.count {
                if i == loc {
                    invitationHandlers[i](true, baseSession);
                }
                else {
                    invitationHandlers[i](false, baseSession);
                }
            }
        }
        NSLog("\n\nAccepted Invitation\n\n");
    }
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        if chosenHost == nil { return; }
        if chosenHost! != peerID { return; }
        if state == MCSessionState.notConnected {
            baseVC.throwError("Error: Host Disconnected.");
        }
    }
    
    /* Sending & Receiving Data */
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID) {
        if data.first == nil {
            baseVC.throwError("Host received invalid Data object in session.");
        }
        else if data.first! == MessageClass.timeCalibration.rawValue {
            //Time String Received -- Responds by sending a corresponding timeCalibration.
            do {
                try baseSession.send(TimeCalibration(NSDate()).export() as Data, toPeers: [chosenHost!], with: MCSessionSendDataMode.reliable);
            }
            catch is NSError {
                baseVC.throwError("Guest cannot parse TimeCalibration TimeString");
            }
        }
        else if data.first! == MessageClass.youtubeLink.rawValue {
            //YouTubeLink Received -- Responds by storing the YouTube video link.
            do {
                youTubeLink = try YouTubeLink(data as NSData).link;
                NSLog("\n\nReceived YouTube Link\n\n");
            }
            catch is NSError {
                baseVC.throwError("Guest cannot parse YouTube Link.");
            }
        }
        else if data.first! == MessageClass.timePlaying.rawValue {
            //YouTube Play Time received
            do {
                youTubePlayTime = try TimePlaying(data as NSData).date;
                NSLog("\n\nReceived YouTube PlayTime \(TimeString.FORMATTER.string(from:youTubePlayTime! as Date))\n\n");
                if (self.baseVC is WaitingViewController) {
                    OperationQueue.main.addOperation {
                        (self.baseVC as! WaitingViewController).advance();
                        (self.baseVC as! GuestVideoViewController).scheduleVideoAt(self.youTubePlayTime! as Date);
                    }
                }
            }
            catch is NSError {
                baseVC.throwError("Guest cannot parse YouTube Play Time.");
            }
        }
        else if data.first! == MessageClass.stopMessage.rawValue {
            //Guest stops playing immediately.
            
        }
    }
    
    
    
    
    
    
    //Unused Delegate Methods
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {
    }
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL,
                 withError error: Error?) {
    }
    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {
    }
    /*
    func session(_ session: MCSession,
                 didReceiveCertificate certificate: [Any]?,
                 fromPeer peerID: MCPeerID,
                 certificateHandler: @escaping (Bool) -> Void) {
    }
    */
}
