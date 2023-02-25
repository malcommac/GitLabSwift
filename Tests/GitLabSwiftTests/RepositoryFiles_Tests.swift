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
import XCTest
@testable import GitLabSwift
import RealHTTP

final class GitLabSwift_RepositoryFilesTests: XCTestCase {
    
    public func test_fileInfo() async throws {
        let result = await catchErrors {
            let response = try await gitlab.repositoryFiles.fileInfo(
                path: ".VERSION",
                ref: "89fbaaf60d22358ba607d7f3d38fc47360b706a9",
                project: .id(1097)
            )
            guard let fileInfo = try response.decode() else {
                XCTFail()
                return
            }
            XCTAssertNotNil(fileInfo)
            print(fileInfo)
        }
        XCTAssertTrue(result)
    }
    
}
