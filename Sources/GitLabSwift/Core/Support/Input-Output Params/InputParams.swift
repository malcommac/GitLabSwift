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

public enum InputParams {}

public protocol APIRequestsURLConvertible {
    var options: OptionsConvertible { get }
}

public protocol URLEncodable: Any {
    var encodedValue: String { get }
}

// MARK: - Standard Swift Types Support

extension String: URLEncodable {
    public var encodedValue: String {
        self
    }
}

extension Int: URLEncodable {
    public var encodedValue: String {
        "\(self)"
    }
}

extension Bool: URLEncodable {
    public var encodedValue: String {
        "\(self ? "true": "false")"
    }
}

extension Date: URLEncodable {
    public var encodedValue: String {
        ISO8601DateFormatter().string(from: self)
    }
}

extension Array: URLEncodable where Element == Int {
    public var encodedValue: String {
        "[\(map({ "\($0)" }).joined(separator: ","))]"
    }
}

// MARK: - Custom Types Support

public extension InputParams {
    
    /// The state event of the milestone
    enum MilestoneState: String, URLEncodable {
        case close
        case activate
        
        public var encodedValue: String { rawValue }
    }
    
    /// Return issues assigned to the given user id.
    enum IdSearch: URLEncodable {
        /// Returns unassigned issues.
        case none
        /// Returns issues with an assignee.
        case any
        /// Specific user id.
        case id(Int)
        
        public var encodedValue: String {
            switch self {
            case .none: return "None"
            case .any: return "Any"
            case .id(let v): return String(v)
            }
        }
    }
    
    enum MilestoneScope: String, URLEncodable {
        case running
        case pending
        case finished
        case branches
        case tags
        
        public var encodedValue: String { rawValue }
    }
    
    enum PipelineSource: String, URLEncodable {
        case push
        case web
        case trigger
        case schedule
        case api
        case external
        case pipeline
        case chat
        case webide
        case merge_request_event
        case external_pull_request_event
        case parent_pipeline
        case ondemand_dast_scan
        case ondemand_dast_validation
        
        public var encodedValue: String { rawValue }
    }
    
    enum PipelineStatus: String, URLEncodable {
        case created
        case waiting_for_resource
        case preparing
        case pending
        case running
        case success
        case failed
        case canceled
        case skipped
        case manual
        case scheduled
        
        public var encodedValue: String { rawValue }
    }
    
    /// Scope of the job.
    enum JobScope: String, URLEncodable {
        case created
        case pending
        case running
        case failed
        case success
        case canceled
        case skipped
        case waiting_for_resource
        case manual
        
        public var encodedValue: String { rawValue }
    }

    /// Defines the weight of issues.
    enum IssuesWeight: URLEncodable {
        case none
        case any
        case value(Int)
        
        public var encodedValue: String {
            switch self {
            case .none: return "None"
            case .any: return "Any"
            case .value(let v): return String(v)
            }
        }
    }
    
    /// Defines the state of issues.
    enum IssuesState: String, URLEncodable {
        case all
        case opened
        case closed
        
        public var encodedValue: String { rawValue }
    }
    
    /// Defines the scope for issues.
    enum IssuesScope: String, URLEncodable {
        case created_by_me
        case assigned_to_me
        case all
        
        public var encodedValue: String { rawValue }
    }

    /// Order returned issues by sorting style.
    enum IssuesOrder: String, URLEncodable {
        case created_at
        case due_date
        case label_priority
        case milestone_due
        case popularity
        case priority
        case relative_position
        case title
        case updated_at
        case weight
        
        public var encodedValue: String { rawValue }
    }
    
    /// Return issues reacted by the authenticated user by the given emoji
    enum EmojiSearch: URLEncodable {
        /// returns issues not given a reaction.
        case none
        /// returns issues given at least one reaction.
        case any
        /// specify reaction emoji.
        case reaction(String)
        
        public var encodedValue: String {
            switch self {
            case .none: return "None"
            case .any: return "Any"
            case .reaction(let r): return r
            }
        }
    }

    /// Filter issues assigned to milestones with a given timebox value.
    enum MilestoneIDSearch: URLEncodable {
        /// Lists all issues with no milestone
        case none
        /// Lists all issues that have an assigned milestone.
        case any
        /// Lists all issues assigned to milestones due in the future.
        case upcoming
        /// Lists all issues assigned to open, started milestones.
        case started
        /// Specify the id of the milestone to filter.
        case id(String)
        
        
        public var encodedValue: String {
            switch self {
            case .none: return "None"
            case .any: return "Any"
            case .upcoming: return "Upcoming"
            case .started: return "Started"
            case .id(let id): return id
            }
        }
    }
    
    /// Comma-separated list of label names, issues must have all labels to be returned
    enum LabelsSearch: URLEncodable {
        /// None lists all issues with no labels
        case none
        /// Any lists all issues with at least one label.
        case any
        /// List issues with these labels.
        case list([String])
        
        public var encodedValue: String {
            switch self {
            case .none: return "None"
            case .any: return "Any"
            case .list(let list): return list.joined(separator: ",")
            }
        }
    }
    
    enum SearchInScope: URLEncodable {
        case title
        case description
        case both
        
        public var encodedValue: String {
            switch self {
            case .title: return "title"
            case .description: return "description"
            case .both: return "title,description"
            }
        }
    }
    
    enum HealthStatus: URLEncodable {
        case none
        case any
        case custom(String)
        
        public var encodedValue: String {
            switch self {
            case .none: return "None"
            case .any: return "Any"
            case .custom(let value): return value
            }
        }
    }
    
    enum DueDate: String, URLEncodable {
        case noDueDate = "0"
        case any
        case today
        case tomorrow
        case overdue
        case week
        case month
        case nextMmonthAndPreviousTwoWeeks = "next_month_and_previous_two_weeks"

        public var encodedValue: String { rawValue }
    }
        
    enum CommitRefType: String, URLEncodable {
        case branch
        case tag
        case all
        
        public var encodedValue: String { rawValue }
    }
    
    enum IssueType: String, URLEncodable {
        case issue
        case incident
        case test_case
        
        public var encodedValue: String { rawValue }
    }
    
    enum MilestoneEditState: String, URLEncodable {
        case activate
        case close
        
        public var encodedValue: String { rawValue }
    }
    
    /// A simple class which encapsulate a Date and print only it with no time.
    class DateOnly: URLEncodable {
        
        public var date: Date
        
        public init(date: Date) {
            self.date = date
        }
        
        public var encodedValue: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            return formatter.string(from: date)
        }
        
    }
    
    enum Search: URLEncodable {
        case beginWith(String)
        case endWith(String)
        case contains(String)
        
        public var encodedValue: String {
            switch self {
            case .beginWith(let s): return "^\(s)"
            case .endWith(let s): return "\(s)$"
            case .contains(let s): return s
            }
        }
    }
    
    /// The access levels are defined as defined in
    /// [doc](https://docs.gitlab.com/ee/api/protected_branches.html)
    enum AccessLevel: Int, URLEncodable {
        case noAccess = 0
        case developer = 30
        case maintainer = 40
        case admin = 60
        
        public var encodedValue: String { "\(rawValue)" }
    }
    
    struct DiscussionSnippet {
        public let snippet_id: Int
        public let discussion_id: Int
        public let note_id: Int
    }
    
    enum ArchiveFormat: String, URLEncodable {
        case bz2
        case tar
        case tar_bz2 = "tar.bz2"
        case tar_gz = "tar.gz"
        case tb2
        case tbz
        case tbz2
        case zip
        
        public var encodedValue: String { rawValue }
    }
    
    enum ContributorsOrder: String, URLEncodable {
        case email
        case commits
        
        public var encodedValue: String { rawValue }
    }
    
    enum TagsOrder: String, URLEncodable {
        case updated
        case name
        case version
        
        public var encodedValue: String { rawValue }
    }
    
    enum ProjectID: URLEncodable, ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, CustomStringConvertible {
        public typealias StringLiteralType = String
        public typealias IntegerLiteralType = Int
        
        case id(Int)
        case path(String)
        
        public init(integerLiteral value: Int) {
            self = .id(value)
        }
        
        public init(stringLiteral value: String) {
            self = .path(value)
        }
        
        public var encodedValue: String {
            switch self {
            case .id(let id): return "\(id)"
            case .path(let path): return path
            }
        }
        
        public var description: String {
            switch self {
            case .id(let id): return "\(id)"
            case .path(let path): return path
            }
        }
        
    }
    
    enum Flag: String, URLEncodable {
        case enabled
        case disabled
        
        public var encodedValue: String { rawValue }
    }
    
    enum AccessLevelFlag: String, URLEncodable {
        case enabled
        case disabled
        case `private`
        
        public var encodedValue: String { rawValue }
    }
    
    enum DeployStrategy: String, URLEncodable {
        case continuous
        case manual
        case timedIncremental
        
        public var encodedValue: String { rawValue }
    }
    
    enum Sort: String, URLEncodable {
        case asc
        case desc
        
        public var encodedValue: String { rawValue }
    }
    
    enum PipelineOrder: String, URLEncodable {
        case id
        case status
        case ref
        case updated_at
        case user_id
        
        public var encodedValue: String { rawValue }
    }
    
    enum UsersOrder: String, URLEncodable {
        case id
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
        public var encodedValue: String { rawValue }
    }
    
    /// The role assigned to a user or group.
    /// [Documentation](https://docs.gitlab.com/ee/api/members.html#roles)
    enum AccessLevelAssign: Int, URLEncodable {
        case noAccess = 0
        case minimalAccess = 5
        case guest = 10
        case reporter = 20
        case maintainer = 40
        case owner = 50
        
        public var encodedValue: String { "\(rawValue)" }
    }
    
    struct AccessLevelNode {
        public let access_level: Int
        
        
    }
    
    enum ProjectOrder: String, URLEncodable {
        case id = "id"
        case name = "name"
        case path = "path"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastActivity = "last_activity_at"
        case similarity = "similarity"
        
        public var encodedValue: String { rawValue }
    }
    
    enum ProjectVisibility: String, URLEncodable {
        case `public`
        case `internal`
        case `private`
        
        public var encodedValue: String { rawValue }
    }
    
    enum CommitOrder: String, URLEncodable {
        case `default`
        case topo
        
        public var encodedValue: String { rawValue }
    }
    
    enum CommitScope: String, URLEncodable {
        case branch
        case tag
        case all
        
        public var encodedValue: String { rawValue }
    }
    
    enum CommitCommentLineType: String, URLEncodable {
        case new, old
        public var encodedValue: String { rawValue }
    }
    
}
