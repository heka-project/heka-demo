//
//  Chain.swift
//  Demo
//
//  Created by Sean Lim on 9/11/18.
//  Copyright © 2018 Heka. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON
import SwiftHash

class Fragment {
	
	var md5: String?
	var nodes: [[String: Any]] = []
	
	init() {
		
	}
	
	init(meta: [String: Any]) {
		self.nodes.append(meta)
		self.updateHash()
	}
	
	func addNode(meta: [String: Any]) {
		self.nodes.append(meta)
		self.nodes = self.nodes.sorted{
			return ($0["qty"] as! Int) < ($1["qty"] as! Int)
		}
		self.updateHash()
	}
	
	func updateHash() {
		let stringRepresentation = mapToString()
		// Generate a hash of self
		self.md5 = MD5(stringRepresentation)
		print("Generated hash \(self.md5)")
	}
	
	// Map contents to a string
	private func mapToString() -> String {
		return JSON([
			"nodes": self.nodes.map{$0.description}
			]).rawString()!
	}
	
	
}