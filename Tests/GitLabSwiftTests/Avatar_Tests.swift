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

import XCTest
@testable import GitLabSwift
import RealHTTP

final class GitLabSwift_AvatarTests: XCTestCase {
    
    public func test_avatar() async throws {
        let result = await catchErrors {
            let response = try await gitlab.avatar.url(email: "daniele.margutti@immobiliare.it")
            guard let avatar = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(avatar)
            print(avatar)
        }
        XCTAssertTrue(result)
    }
    
}

