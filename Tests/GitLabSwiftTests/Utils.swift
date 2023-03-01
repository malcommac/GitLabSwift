//
//  GitLabSwift
//  Async/Await client for GitLab API v4, for Swift
//
//  Created & Maintained by Daniele Margutti
//  Email: hello@danielemargutti.com
//  Web: http://www.danielemargutti.com
//
//  Copyright ©2023 Daniele Margutti.
//  Licensed under MIT License.
//

import Foundation
@testable import GitLabSwift
import RealHTTP

let gitlab: GLApi = {
    let config = Config(baseURL: "", {
       // $0.apiVersion = "4"
        $0.token = ""
    })
    return .init(config: config)
}()

public func catchErrors(_ block: (() async throws -> Void)) async -> Bool {
    do {
        try await block()
        return true
    } catch DecodingError.dataCorrupted(let context) {
        print(context)
    } catch DecodingError.keyNotFound(let key, let context) {
        print("Key '\(key)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch DecodingError.valueNotFound(let value, let context) {
        print("Value '\(value)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch DecodingError.typeMismatch(let type, let context) {
        print("Type '\(type)' mismatch:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch {
        if let gitlabError = error as? GLNetworkError {
            if gitlabError.statusCode == .notFound {
                print("This call is not supported by the WS. Cannot be tested.")
                return true
            } else {
                print("Gitlab error: \(gitlabError.localizedDescription)")
            }
        } else {
            print("Other error: \(error.localizedDescription)")
        }
    }
    return false
}

extension String {
    
    func trunc(_ length: Int, trailing: String = "…") -> String {
        let maxLength = length - trailing.count
        guard maxLength > 0, !self.isEmpty, self.count > length else {
            return self
        }
        return self.prefix(maxLength) + trailing
    }
    
}
