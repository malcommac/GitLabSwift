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

final class GitLabSwift_PipelinesTests: XCTestCase {
    
    public func test_createPipeline() async throws {
        let result = await catchErrors {
            let response = try await gitlab.pipelines.create(ref: "main", project: .id(1097), variables: [
                ["key": "VAR1", "value": "hello"],
                ["key": "VAR2", "value": "world"]
            ])
            guard let discussions = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(discussions)
            print(discussions)
        }
        XCTAssertTrue(result)
    }
    
}
