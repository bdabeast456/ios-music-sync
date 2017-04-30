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
    
    var peerID : MCPeerID;
    var serviceAdvertiser : MCNearbyServiceAdvertiser;
    var serviceBrowser : MCNearbyServiceBrowser;
    var baseSession : MCSession;
    
    let serviceType : String = "music_service";
    
    init (_ displayName: String, _ discoveryInfo: [String:String]) {
        peerID = MCPeerID(displayName: displayName);
        serviceAdvertiser = MCNearbyServiceAdvertiser(
            peer: peerID,
            discoveryInfo: discoveryInfo,
            serviceType: serviceType);
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType);
        baseSession = MCSession(peer: peerID);
        super.init();
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer();
        serviceBrowser.stopBrowsingForPeers();
        baseSession.disconnect();
        //super.deinit(); LOOK AT THIS
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

    var discoveredGuests : Set<MCPeerID> = Set<MCPeerID>();
    var finalGuests : Set<MCPeerID> = Set<MCPeerID>();
    
    init (displayName : String) {
        super.init(displayName, ["ID":"HOST"]);
        serviceAdvertiser.delegate = self;
        serviceBrowser.delegate = self;
        baseSession.delegate = self;
        startDiscovery();
    }
    
    /* Discover Guests */
    //MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        throwError("Error: Could not start MCNearbyServiceAdvertiser");
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        throwError("Error: Host cannot respond to invitations");
    }
    
    //MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error) {
        throwError("Error: Could not start MCNearbyServiceBrowser");
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        if info!["ID"] == "HOST" {return;}
        discoveredGuests.insert(peerID);
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        //if info!["ID"] == "HOST" {return;} LOOK AT THIS
        discoveredGuests.remove(peerID);
    }
    
    /* Invite Guests */
    func sendInvitations (toGuests guests: Array<MCPeerID>) {
        for peer in guests {
            serviceBrowser.invitePeer(peer, to: baseSession, withContext: nil, timeout: 10);
        }
    }
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        if state == MCSessionState.connected {
            finalGuests.insert(peerID);
        }
        else if state == MCSessionState.notConnected {
            finalGuests.remove(peerID);
        }
    }
    
    /* Comunicate with Guests */
    func getTimeDelays () {
        
    }
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID) {
        //Sending / Receiving Blocks of Data
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
                 didReceiveCertificate certificate: [Any]?,
                 fromPeer peerID: MCPeerID,
                 certificateHandler: @escaping (Bool) -> Void) {
    }
    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {
    }
    
}

class Guest : Networker, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    var invitingHosts : Array<MCPeerID> = Array<MCPeerID>();
    var invitationHandlers : Array<(Bool, MCSession?) -> Void> = Array<(Bool, MCSession?) -> Void>();
    var chosenHost : MCPeerID? = nil;
    
    init (displayName : String) {
        super.init(displayName, ["ID":"GUEST"]);
        serviceAdvertiser.delegate = self;
        serviceBrowser.delegate = self;
        baseSession.delegate = self;
        startDiscovery();
    }
    
    /* Become Discoverable */
    //MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        throwError("Error: Could not start MCNearbyServiceAdvertiser");
    }
    
    /* Receive Invitations */
    //MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitingHosts.append(peerID);
        invitationHandlers.append(invitationHandler);
    }
    
    //MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error) {
        throwError("Error: Could not start MCNearbyServiceBrowser");
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
        var loc : Int = -1;
        for i in 0..<invitingHosts.count {
            if invitingHosts[i].isEqual(peerID) {
                loc = i;
            }
        }
        if loc == -1 { throwError("Error: Did not receive invitation from indicated host"); }
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
    }
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        if chosenHost == nil { return; }
        if chosenHost! != peerID { return; }
        if state == MCSessionState.notConnected {
            throwError("Error: Host Disconnected.");
        }
    }
    
    /* Sending & Receiving Data */
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID) {
        
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
    func session(_ session: MCSession,
                 didReceiveCertificate certificate: [Any]?,
                 fromPeer peerID: MCPeerID,
                 certificateHandler: @escaping (Bool) -> Void) {
    }
}
