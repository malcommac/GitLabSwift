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
import RealHTTP
import Glider

// MARK: - APIs Service

open class APIs {
    
    // MARK: - Private Properties
    
    /// Service.
    internal private(set) weak var gitlab: GLApi!
    
    // MARK: - Initialization
    
    /// Initialize with given gitlab service.
    ///
    /// - Parameter gitlab: gitlab.
    init(gitlab: GLApi) {
        self.gitlab = gitlab
    }
    
}

// MARK: - APIs Client

/// Entry point access for all GitLab APIs.
public final class GLApi {
    
    // MARK: - Public Properties
    
    /// Configuration used for gitlab service communication.
    public let config: Config
    
    /// Logger instance
    public var logger: Glider.Log
    
    // MARK: - APIs Services

    public lazy var users: APIs.Users = { .init(gitlab: self) }()
    public lazy var projects: APIs.Projects = { .init(gitlab: self) }()
    public lazy var branches: APIs.Branches = { .init(gitlab: self) }()
    public lazy var protectedBranches: APIs.ProtectedBranches = { .init(gitlab: self) }()
    public lazy var commits: APIs.Commits = { .init(gitlab: self) }()
    public lazy var milestones: APIs.ProjectMilestones = { .init(gitlab: self) }()
    public lazy var groupMilestones: APIs.GroupMilestones = { .init(gitlab: self) }()
    public lazy var labels: APIs.Labels = { .init(gitlab: self) }()
    public lazy var groupLabels: APIs.GroupLabels = { .init(gitlab: self) }()
    public lazy var discussions: APIs.Discussions = { .init(gitlab: self) }()
    public lazy var issues: APIs.Issues = { .init(gitlab: self) }()
    public lazy var epicIssues: APIs.EpicIssues = { .init(gitlab: self) }()
    public lazy var issuesStatistics: APIs.IssuesStatistics = { .init(gitlab: self) }()
    public lazy var jobs: APIs.Jobs = { .init(gitlab: self) }()
    public lazy var pipelines: APIs.Pipelines = { .init(gitlab: self) }()
    public lazy var repositories: APIs.Repositories = { .init(gitlab: self) }()
    public lazy var repositoryFiles: APIs.RepositoryFiles = { .init(gitlab: self) }()
    public lazy var tags: APIs.Tags = { .init(gitlab: self) }()
    public lazy var avatar: APIs.Avatar = { .init(gitlab: self) }()
    public lazy var mergeRequest: APIs.MergeRequests = { .init(gitlab: self) }()

    // MARK: - Private Properties
    
    /// HTTP client used to make requests.
    private var httpClient: HTTPClient
    
    // MARK: - Initialization
    
    /// Initialize a new gitlab service with given configuration.
    ///
    /// - Parameter config: configuration object.
    public init(config: Config) {
        self.config = config
        self.logger = .init(configuration: config.loggerConfiguration)
        self.httpClient = .init(baseURL: nil)
        self.httpClient.delegate = self
    }
    
    // MARK: - Public Functions
    
    /// Execute an asynchronous request to gitlab server.
    ///
    /// - Parameter request: request to execute.
    /// - Returns: response.
    public func execute<T>(_ request: GLRequest) async throws -> GLResponse<T> {
        let httpRequest = try request.httpRequest(forClient: self)
        let response = try await GLResponse<T>(httpResponse: httpRequest.fetch(httpClient), decoder: config.jsonDecoder)
        response.gitlab = self
        response.request = request
        if let error = GLNetworkError(response: response, request: request) {
            throw error
        }
        return response
    }
    
}

// MARK: - HTTPClientDelegate

extension GLApi: HTTPClientDelegate {
    
    public func client(_ client: HTTPClient,
                       didEnqueue request: ExecutedRequest) {
        logger.debug?.write(msg: "Executing [\(request.request.method.description)]: \(request.request.url!.absoluteString)")
    }
    
    public func client(_ client: HTTPClient,
                       request: ExecutedRequest,
                       willRetryWithStrategy strategy: HTTPRetryStrategy,
                       afterResponse response: HTTPResponse) {
        
    }
    
    public func client(_ client: HTTPClient,
                       taskIsWaitingForConnectivity request: ExecutedRequest) {
        
    }
    
    public func client(_ client: HTTPClient,
                       willPerformRedirect request: ExecutedRequest,
                       response: HTTPResponse,
                       with newRequest: URLRequest) {
        
    }
    
    public func client(_ client: HTTPClient,
                       didReceiveAuthChallangeFor request: ExecutedRequest,
                       authChallenge: URLAuthenticationChallenge) {
        
    }
    
    public func client(_ client: HTTPClient,
                       didCollectedMetricsFor request: ExecutedRequest,
                       metrics: HTTPMetrics) {
        
    }
    
    public func client(_ client: HTTPClient,
                       didFinish request: ExecutedRequest,
                       response: HTTPResponse) {
        
    }
    
}
