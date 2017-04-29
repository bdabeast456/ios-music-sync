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
    }
    
    func startDiscovery () -> Void {
        serviceAdvertiser.startAdvertisingPeer();
        serviceBrowser.startBrowsingForPeers();
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer();
        serviceBrowser.stopBrowsingForPeers();
        baseSession.disconnect();
    }
    
    
}

class Host : Networker, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {

    var connectedGuests : Set<MCPeerID>;
    
    init (displayName : String) {
        connectedGuests = Set<MCPeerID>();
        super.init(displayName, ["ID":"HOST"]);
        serviceAdvertiser.delegate = self;
        serviceBrowser.delegate = self;
        startDiscovery();
    }
    
    //MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
    
    //MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error) {
        
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        
    }
    
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID) {
        
    }
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
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        
    }
    
}

class Guest : Networker, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    var connectedHost : MCPeerID?;
    
    init (displayName : String) {
        connectedHost = nil;
        super.init(displayName, ["ID":"GUEST"]);
        serviceAdvertiser.delegate = self;
        serviceBrowser.delegate = self;
        startDiscovery();
    }
    
    //MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
    
    //MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error) {
        
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        
    }
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        
    }
    
    //MCSessionDelegate Methods
    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID) {
        
    }
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
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        
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
