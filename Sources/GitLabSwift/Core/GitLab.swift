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

/// Entry point access for all GitLab APIs.
public final class GitLab {
    
    // MARK: - Public Properties
    
    /// Configuration used for gitlab service communication.
    public let config: Config

    public lazy var users: APIService.Users = { .init(gitlab: self) }()
    public lazy var projects: APIService.Projects = { .init(gitlab: self) }()
    public lazy var branches: APIService.Branches = { .init(gitlab: self) }()
    public lazy var protectedBranches: APIService.ProtectedBranches = { .init(gitlab: self) }()
    public lazy var commits: APIService.Commits = { .init(gitlab: self) }()
    public lazy var milestones: APIService.ProjectMilestones = { .init(gitlab: self) }()
    public lazy var groupMilestones: APIService.GroupMilestones = { .init(gitlab: self) }()
    public lazy var labels: APIService.Labels = { .init(gitlab: self) }()
    public lazy var groupLabels: APIService.GroupLabels = { .init(gitlab: self) }()
    public lazy var discussions: APIService.Discussions = { .init(gitlab: self) }()
    public lazy var issues: APIService.Issues = { .init(gitlab: self) }()
    public lazy var epicIssues: APIService.EpicIssues = { .init(gitlab: self) }()
    public lazy var issuesStatistics: APIService.IssuesStatistics = { .init(gitlab: self) }()
    public lazy var jobs: APIService.Jobs = { .init(gitlab: self) }()
    public lazy var pipelines: APIService.Pipelines = { .init(gitlab: self) }()
    public lazy var repositories: APIService.Repositories = { .init(gitlab: self) }()
    public lazy var repositoryFiles: APIService.RepositoryFiles = { .init(gitlab: self) }()
    public lazy var tags: APIService.Tags = { .init(gitlab: self) }()
    public lazy var avatar: APIService.Avatar = { .init(gitlab: self) }()

    // MARK: - Private Properties
    
    /// HTTP client used to make requests.
    private var httpClient: HTTPClient
    
    // MARK: - Initialization
    
    /// Initialize a new gitlab service with given configuration.
    ///
    /// - Parameter config: configuration object.
    public init(config: Config) {
        self.config = config
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
        if let error = GLError(response: response, request: request) {
            throw error
        }
        return response
    }
    
}

// MARK: - HTTPClientDelegate

extension GitLab: HTTPClientDelegate {
    
    public func client(_ client: HTTPClient, didEnqueue request: ExecutedRequest) {
        print("Executing [\(request.request.method.description)]: \(request.request.url!.absoluteString)")
    }
    
    public func client(_ client: HTTPClient, request: ExecutedRequest, willRetryWithStrategy strategy: HTTPRetryStrategy, afterResponse response: HTTPResponse) {
        
    }
    
    public func client(_ client: HTTPClient, taskIsWaitingForConnectivity request: ExecutedRequest) {
        
    }
    
    public func client(_ client: HTTPClient, willPerformRedirect request: ExecutedRequest, response: HTTPResponse, with newRequest: URLRequest) {
        
    }
    
    public func client(_ client: HTTPClient, didReceiveAuthChallangeFor request: ExecutedRequest, authChallenge: URLAuthenticationChallenge) {
        
    }
    
    public func client(_ client: HTTPClient, didCollectedMetricsFor request: ExecutedRequest, metrics: HTTPMetrics) {
        
    }
    
    public func client(_ client: HTTPClient, didFinish request: ExecutedRequest, response: HTTPResponse) {
        
    }
    
}
