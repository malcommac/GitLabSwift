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

final class GitLabSwift_RepositoriesTests: XCTestCase {
    
    public func test_tree() async throws {
        let result = await catchErrors {
            let response = try await gitlab.repositories.list(project: .id(1097), options: {
                $0.recursive = true
            })
            guard let tree = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(tree)
            print(tree)
        }
        XCTAssertTrue(result)
    }
    
    public func test_blob() async throws {
        let result = await catchErrors {
            let response = try await gitlab.repositories.blob(sha: "6e9d06ed953ab2b02763e4514296090f09cd145e", project: .id(1097))
            XCTAssertNotNil(response)
            print(response.httpResponse.data?.asString ?? "")
        }
        XCTAssertTrue(result)
    }
    
    public func test_archive() async throws {
        let result = await catchErrors {
            let response = try await gitlab.repositories.fileArchive(project: .id(1097))
            XCTAssertNotNil(response)
            print("\(response.httpResponse.data?.count ?? 0) bytes")
        }
        XCTAssertTrue(result)
    }
    
    public func test_compare() async throws {
        let result = await catchErrors {
            let response = try await gitlab.repositories.compare(
                project: .id(1097),
                fromSha: "aa6735941119be39845da223068400268892ca89",
                toSha: "89fbaaf60d22358ba607d7f3d38fc47360b706a9",
                straight: false
            )
            guard let comparisonResult = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(comparisonResult)
            print(comparisonResult)
        }
        XCTAssertTrue(result)
    }
    
    public func test_contributors() async throws {
        let result = await catchErrors {
            let response = try await gitlab.repositories.contributors(
                project: .id(1097),
                orderBy: .commits,
                sort: .asc
            )
            guard let contributors = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(contributors)
            print(contributors)
        }
        XCTAssertTrue(result)
    }
    
    public func test_commonAncestor() async throws {
        let result = await catchErrors {
            let response = try await gitlab.repositories.mergeBase(
                project: .id(1097),
                refs: [
                    "aa6735941119be39845da223068400268892ca89",
                    "89fbaaf60d22358ba607d7f3d38fc47360b706a9"
                ]
            )
            guard let info = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(info)
            print(info)
        }
        XCTAssertTrue(result)
    }
    
}
