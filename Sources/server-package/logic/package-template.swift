import Foundation

struct PackageTemplate {
    let files: [TemplateFile]
    
    static func standard(for config: PackageConfig) -> PackageTemplate {
        PackageTemplate(
            files: [
                TemplateFile(
                    name: "state.swift",
                    path: .init(["Sources", config.name]),
                    content: ServerPackageDefaults.State.latest
                ),
                // TemplateFile(
                //     name: "runtime.swift",
                //     path: .init(["Sources", config.name]),
                //     content: ServerPackageDefaults.Runtime.latest
                // ),
                TemplateFile(
                    name: "app.swift",
                    path: .init(["Sources", config.name]),
                    content: ServerPackageDefaults.App.latest
                ),
                TemplateFile(
                    name: "routes.swift",
                    path: .init(["Sources", config.name]),
                    content: """
                    // import Foundation
                    import Server
                    // import Milieu

                    public func routes() throws -> [Route] {
                        return []
                    }

                    // public func routes() throws -> [Route] {
                        // let bearer = try BearerMiddleware(config: config)
                        // let keys = try config.keys()

                        // return Server.routes {
                            // StandardRoutes.listRoutes()
                            // .use(bearer)

                            // post("encrypt") { request in
                                // do {
                                    // let body = try request.extract(Model.EncryptRequest.self)
                                    // let payloadBytes = try JSONEncoder().encode(body.payload)
                                    // let aadBytes = body.aad.flatMap { try? JSONEncoder().encode($0) }

                                    // let result = try Operation.encryptV3(
                                        // publicKey: keys.publicKey,
                                        // json: payloadBytes,
                                        // kid: body.kid ?? "local-dev",
                                        // ttl: body.ttl,
                                        // aadJSON: aadBytes,
                                    // )

                                    // return try result.response()
                                // } catch {
                                    // return .badRequest(body: "Invalid request: \\(error.localizedDescription)")
                                // }
                            // }
                            // .use(bearer)

                            // post("decrypt") { request in
                                // do {
                                    // let body = try request.extract(Model.DecryptRequest.self)
                                    // let aadBytes = body.aad.flatMap { try? JSONEncoder().encode($0) }

                                    // let plain = try Operation.decryptV3(
                                        // privateKey: keys.privateKey,
                                        // input: body.envelope,
                                        // aadJSON: aadBytes
                                    // )

                                    // let string = String(data: plain, encoding: .utf8)

                                    // guard let string else {
                                        // return .internalServerError(body: "A failure occurred in the decryption process")
                                    // }

                                    // return .text(string)
                                // } catch {
                                    // return .badRequest(body: "Invalid request: \\(error.localizedDescription)")
                                // }
                            // }
                            // .use(bearer)
                        // }
                    // }
                    """
                ),
                TemplateFile(
                    name: "model.swift",
                    path: .init(["Sources", config.name, "objects", "model"]),
                    content: """
                    public enum Model {}
                    """
                ),
                TemplateFile(
                    name: "operation.swift",
                    path: .init(["Sources", config.name, "objects", "operation"]),
                    content: """
                    public enum Operation {}
                    """
                ),
            ]
        )
    }
}
