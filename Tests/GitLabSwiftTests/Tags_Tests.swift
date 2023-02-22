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

final class GitLabSwift_TagsTests: XCTestCase {
    
    public func test_tags() async throws {
        let result = await catchErrors {
            let response = try await gitlab.tags.list(project: .id(1097))
            response.writeRawResponse("tags")
            guard let tags = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(tags)
            print(tags)
        }
        XCTAssertTrue(result)
    }
    
    public func test_get() async throws {
        let result = await catchErrors {
            let response = try await gitlab.tags.get(name: "", project: .id(1097))
            response.writeRawResponse("tag")
            guard let tag = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(tag)
            print(tag)
        }
        XCTAssertTrue(result)
    }
    
}
