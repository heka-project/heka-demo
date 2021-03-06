//
//  Service.swift
//  ConnectedColors
//
//  Created by Sean Lim on 18/10/18.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import ObjectMapper
import SwiftyJSON

class P2PService: NSObject {
	
	var delegate: P2PServiceDelegate?
	
	lazy var session: MCSession = {
		let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)
		session.delegate = self
		return session
	}()
	
	var fragmentCache: Fragment?
	
	var baseFrame: [String: String] = [
		"name": userName,
		"qty": userNrics,
		"id": P2PClientID!,
		"batch_id": "batch_1",
		"collected": String(collected),
		"isCurrent": String(isCurrent),
	]
	
	private let serviceType = secrets.value(forKey: "root") as! String
	internal let peerID = MCPeerID(displayName: P2PClientID!)
	
	private let serviceAdvertiser: MCNearbyServiceAdvertiser
	private let serviceBrowser: MCNearbyServiceBrowser
	
	override init() {
		self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
		self.serviceBrowser = MCNearbyServiceBrowser.init(peer: peerID, serviceType: serviceType)
		
		super.init()

		self.serviceAdvertiser.delegate = self
		self.serviceAdvertiser.startAdvertisingPeer()
		
		self.serviceBrowser.delegate = self
		self.serviceBrowser.startBrowsingForPeers()
		
		self.fragmentCache = Fragment(meta: baseFrame)
	}
	
	deinit {
		self.serviceAdvertiser.stopAdvertisingPeer()
		self.serviceBrowser.stopBrowsingForPeers()
	}
	
	private func send(_ fragment: FragmentMessage) {
		print("Network: <==| \(try! JSON(data: fragment.toJSONString()!.data(using: .utf8)!))")
		if session.connectedPeers.count > 0 {
			do {
				try self.session.send(try! JSON(parseJSON: fragment.toJSONString() ?? "{}").rawData(), toPeers: session.connectedPeers, with: .reliable)
			} catch {
				print("P2P: ⚠️ Fragment delivery failed with error \(error.localizedDescription)")
        debug.append("P2P: ⚠️ Fragment delivery failed with error \(error.localizedDescription)\n")
			}
		}
	}
	
	internal func sayHello() {
		print("P2P: 👋 Saying hello...")
    debug.append("P2P: 👋 Saying hello...\n")
		let fragmentMessage = FragmentMessage(type: .SAY_HELLO, fragment: self.fragmentCache!)
		self.send(fragmentMessage)
	}
	
	internal func updatePeers() {
		print("P2P: 🔗 Updating peers...")
    debug.append("P2P: 🔗 Updating peers...\n")
		let fragmentMessage = FragmentMessage(type: .UPDATE, fragment: self.fragmentCache!)
		self.send(fragmentMessage)
	}
}
