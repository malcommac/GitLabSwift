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

final class GitLabSwift_LabelsTests: XCTestCase {
    
    public func test_list() async throws {
        let result = await catchErrors {
            let response = try await gitlab.labels.list(project: .id(1097), options: {
                $0.withCounts = true
            })
            guard let labels = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(labels)
            print("Listing \(labels.count) of \(response.totalItems ?? 0) labels:")
            for label in labels {
                print("  - \(label.id): \(label.name)")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_labelDetail() async throws {
        let result = await catchErrors {
            let response = try await gitlab.labels.get(1954, project: .id(1097))
            guard let label = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(label)
            print(label)
        }
        XCTAssertTrue(result)
    }
    
    public func test_createAndDeleteLabel() async throws {
        let result = await catchErrors {
            let labelName = "My New Label"
            let response = try await gitlab.labels.create(name: labelName,
                                                          color: "#0000CD",
                                                          project: .id(2008), options: {
                $0.description = "Description of the label"
            })
            guard let label = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(label)
            print(label)
            
            // Delete label
            let respDelete = try await gitlab.labels.delete(String(label.id), project: .id(2008))
        }
        XCTAssertTrue(result)
    }
    
    public func test_editLabel() async throws {
        let result = await catchErrors {
            // Get any label
            guard let anyLabel = try await gitlab.labels.list(project: .id(2008)).decode()?.first else {
                XCTFail()
                return
            }
            
            print(anyLabel)
            
            // edit label
            let response = try await gitlab.labels.edit(String(anyLabel.id), project: .id(2008), options: {
                $0.description = "New Description"
                $0.color = "#B22222"
                $0.newName = "Modified Name"
            })
        }
        XCTAssertTrue(result)
    }
    
    public func test_promoteToGroup() async throws {
        let result = await catchErrors {
            // Get any label
            guard let anyLabel = try await gitlab.labels.list(project: .id(2008)).decode()?.first else {
                XCTFail()
                return
            }
            
            print(anyLabel)
            
            // edit label
            let _ = try await gitlab.labels.promoteToGroup(label: String(anyLabel.id), project: .id(2008))
        }
        XCTAssertTrue(result)
    }
    
    
}

