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

// MARK: - Pipelines + URLs

extension APIs.Pipelines {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/projects/{id}/pipelines"
        case get = "/projects/{id}/pipelines/{pipeline_id}"
        case variables = "/projects/{id}/pipelines/{pipeline_id}/variables"
        case test_report = "/projects/{id}/pipelines/{pipeline_id}/test_report"
        case test_report_summary = "/projects/{id}/pipelines/{pipeline_id}/test_report_summary"
        case latest = "/projects/{id}/pipelines/latest"
        case create = "/projects/{id}/pipeline"
        case retry = "/projects/{id}/pipelines/{pipeline_id}/retry"
        case cancel = "/projects/{id}/pipelines/{pipeline_id}/cancel"

        public var value: String { rawValue }
    }
    
}

// MARK: - Pipelines + APIs

extension APIs {
    
    /// Pipelines API.
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html)
    public class Pipelines: APIs {
    
        /// List pipelines in a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#list-project-pipelines)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - options: configuration callback.
        public func list(project: InputParams.Project,
                         options: ((SearchOptions) -> Void)? = nil) async throws -> GLResponse<[GLModel.Pipeline]> {
            let options = SearchOptions(project: project, options)
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
        }
        
        /// Get one pipeline from a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-a-single-pipeline)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: list of pipelines
        public func get(pipeline: Int,
                        project: InputParams.Project) async throws -> GLResponse<[GLModel.Pipeline]> {
            let options = OutputParamsCollection([
                OutputParam(key: "pipeline_id", pipeline),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.get, options: options))
        }
        
        /// Get variables of a pipeline.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-variables-of-a-pipeline)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: list of variables
        public func variables(pipeline: Int,
                              project: InputParams.Project) async throws -> GLResponse<[GLModel.Pipeline.Variable]> {
            let options = OutputParamsCollection([
                OutputParam(key: "pipeline_id", pipeline),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.variables, options: options))
        }
        
        /// Get a pipeline’s test report.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-a-pipelines-test-report)
        ///
        /// - Parameters:
        ///   - id: The ID of a pipeline.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: report of the test.
        public func testReport(pipeline: Int,
                               project: InputParams.Project) async throws -> GLResponse<GLModel.Pipeline.TestReport> {
            let options = OutputParamsCollection([
                OutputParam(key: "pipeline_id", pipeline),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.test_report, options: options))
        }
        
        /// Get a pipeline’s test report summary.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-a-pipelines-test-report-summary)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: summary
        public func testReportSummary(pipeline: Int,
                                      project: InputParams.Project) async throws -> GLResponse<GLModel.Pipeline.TestSummary> {
            let options = OutputParamsCollection([
                OutputParam(key: "pipeline_id", pipeline),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.test_report_summary, options: options))
        }
        
        /// Get the latest pipeline for a specific ref in a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-the-latest-pipeline)
        ///
        /// - Parameters:
        ///   - project: project.
        ///   - ref: The branch or tag to check for the latest pipeline.
        ///          Defaults to the default branch when not specified.
        /// - Returns: pipeline
        public func latest(project: InputParams.Project,
                           ref: String? = nil) async throws -> GLResponse<GLModel.Pipeline> {
            let options = OutputParamsCollection([
                OutputParam(key: "ref", ref),
                OutputParam(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.latest, options: options))
        }
        
        /// Create a new pipeline.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#create-a-new-pipeline)
        ///
        /// - Parameters:
        ///   - ref: The branch or tag to run the pipeline on.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        ///   - variables: variables available in the pipeline.
        /// - Returns: new created pipeline
        public func create(ref: String,
                           project: InputParams.Project,
                           variables: [[String: Any]]) async throws -> GLResponse<GLModel.Pipeline> {
            let options = OutputParamsCollection([
                OutputParam(key: "ref", ref),
                OutputParam(key: "id", project),
                OutputParam(key: "variables", variables)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.create, options: options))
        }
        
        /// Retry jobs in a pipeline.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#retry-jobs-in-a-pipeline)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: retried pipeline
        public func retry(pipeline: Int,
                          project: InputParams.Project) async throws -> GLResponse<GLModel.Pipeline> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "pipeline_id", pipeline)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.retry, options: options))
        }
        
        /// Cancel a pipeline’s jobs.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#cancel-a-pipelines-jobs)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: cancelled pipeline
        public func cancel(pipeline: Int,
                           project: InputParams.Project) async throws -> GLResponse<GLModel.Pipeline> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "pipeline_id", pipeline)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.cancel, options: options))
        }
        
        /// Deleting a pipeline expires all pipeline caches, and deletes all immediately related objects,
        /// such as builds, logs, artifacts, and triggers.
        /// This action cannot be undone.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#delete-a-pipeline)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: no response
        public func delete(pipeline: Int,
                           project: InputParams.Project) async throws -> GLResponse<GLModel.NoResponse> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "pipeline_id", pipeline)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: URLs.get, options: options))
        }
        
    }
    
}
