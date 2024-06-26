//
//  SingleNodeTARUT.swift
//
//
//  Created by Charles Roth on 2024-06-25.
//

import Foundation

@main
struct SingleNodeTARUT {
    static func main() async throws {
        let stderr = StandardError()
        let node = Node()
        
        while let line = readLine(strippingNewline: true) {
            let data = line.data(using: .utf8)!
            let decoder = JSONDecoder()
            let req = try decoder.decode(MaelstromMessage.self, from: data)
            switch req.body {
            case .initMessage(let body):
                Task {
                    try await node.handleInit(req: req, body: body)
                }
                break
            case .txnMessage(let body):
                Task {
                    try await node.handleTxn(req: req, body: body)
                }
                break
            case .txnRpcMessage(let body):
                Task {
                    try await node.handleTxnRpc(req: req, body: body)
                }
                break
            case .txnRpcOkMessage(let body):
                Task {
                    try await node.handleTxnRpcOk(req: req, body: body)
                }
                break
            default:
                stderr.write("no message handler for: \(req.body)\n")
                break
            }
        }
    }
}
