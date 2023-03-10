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

final class GitLabSwift_ProjectsTests: XCTestCase {
    
    private var anyProject: GLModel.Project!
    
    override func setUp() async throws {
    //    let project = try await gitlab.projects.list().model()?.randomElement()
    //    XCTAssertNotNil(project)
      //  self.anyProject = project
    }
    
    public func test_allProjects() async throws {
        let result = await catchErrors {
            let response = try await gitlab.projects.list()
            guard let projects = try response.decode() else {
                XCTFail()
                return
            }
            
            print("There are \(response.totalItems ?? 0) projects in \(response.totalPages) pages")
            if let anyProject = projects.randomElement() {
                print("Random project \(anyProject.id): \(anyProject.name)")
                XCTAssertNotNil(anyProject.id)
                XCTAssertNotNil(anyProject.name)
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_projectsById() async throws {
        let result = await catchErrors {
            guard let anyProject = try await gitlab.projects.list().decode()?.randomElement() else {
                XCTFail()
                return
            }

            let response = try await gitlab.projects.get(project: .id(anyProject.id))
            let foundProject = try response.decode()
            XCTAssertNotNil(foundProject?.id)
            print("Searching for project info with id \(anyProject.id): \(foundProject!.name)")
        }
        XCTAssertTrue(result)
    }
    
    public func test_ownedProjects() async throws {
        let result = await catchErrors {
            let meUser = try await gitlab.users.me().decode()
            let response = try await gitlab.projects.listUsersProjects(meUser!.id, {
                $0.sort = .desc
                $0.statistics = true
            })
            print("\(meUser!.username) owns \(response.totalItems ?? 0) projects")
            if (response.totalItems ?? 0) > 0 {
                let ownedProject = try response.decode()?.randomElement()
                XCTAssertNotNil(ownedProject?.id)
                XCTAssertNotNil(ownedProject?.name)
                print("Random project is \(ownedProject!.name) - \(ownedProject?.web_url?.absoluteString ?? "-")")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_starredProjects() async throws {
        let result = await catchErrors {
            let meUser = try await gitlab.users.me().decode()
            let response = try await gitlab.projects.listUserStarredProjects(meUser!.id)
            print("\(meUser!.username) starred \(response.totalItems ?? 0) projects")
            if (response.totalItems ?? 0) > 0 {
                let starredProject = try response.decode()?.randomElement()
                XCTAssertNotNil(starredProject?.id)
                XCTAssertNotNil(starredProject?.name)
                print("Random starred project is \(starredProject!.name) - \(starredProject?.web_url?.absoluteString ?? "-")")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_usersForProject() async throws {
        let result = await catchErrors {
            if let anyProject = try await gitlab.projects.list().decode()?.randomElement() {
                let response = try await gitlab.projects.usersList(project: .id(2707))
                print("Project ID \(anyProject.id) has \(response.totalItems ?? 0) members")
                if (response.totalItems ?? 0) > 0 {
                    let allUsers = try response.decode()
                    let anyUser = allUsers?.randomElement()
                    XCTAssertNotNil(anyUser?.id)
                    XCTAssertNotNil(anyUser?.name)
                    print("Random user of project \(anyProject.id) is \(anyUser!.name)")
                }
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_searchProjects() async throws {
        let result = await catchErrors {
            let response = try await gitlab.projects.list(options: {
                $0.orderBy = .id
                $0.statistics = true
                $0.sort = .desc
            })
            print("Found \(response.totalItems ?? 0) project on \(response.totalPages)")
            if (response.totalItems ?? 0) > 1 {
                let foundProjects = try response.decode()
                XCTAssertTrue(foundProjects![0].id > foundProjects![1].id)
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_starrersOfProject() async throws {
        let result = await catchErrors {
            let response = try await gitlab.projects.starrersOfProject(.id(anyProject.id))
            print("Found \(response.totalItems ?? 0) users who starred project \(anyProject.id)")
        }
        XCTAssertTrue(result)
    }
    
    public func test_languagesOfProject() async throws {
        let result = await catchErrors {
            let response = try await gitlab.projects.languagesOfProject(.id(1097))
            let result = try response.decode()
            XCTAssertNotNil(result)
        }
        XCTAssertTrue(result)
    }
    
}
