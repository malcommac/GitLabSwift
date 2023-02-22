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

extension APIOptions {
    
    public class CreateFile: APIOptionsCollection {
        
        /// Name of the new branch to create. The commit is added to this branch.
        @APIOption(key: "branch") public var branch: String?
        
        /// The commit message.
        @APIOption(key: "commit_message") public var commitMessage: String?
        
        /// The file’s content.
        @APIOption(key: "content") public var content: String?
        
        /// URL-encoded full path to new file. For example: lib%2Fclass%2Erb.
        @APIOption(key: "file_path") public var filePath: String?
        
        /// The ID or URL-encoded path of the project owned by the authenticated user.
        @APIOption(key: "id") public var project: DataTypes.ProjectID?
        
        /// The commit author’s email address.
        @APIOption(key: "author_email") public var authorEmail: String?
        
        /// The commit author’s name.
        @APIOption(key: "author_name") public var authorName: String?
        
        /// Change encoding to `base64`. Default is `text`.
        @APIOption(key: "encoding") public var encoding: String?
        
        /// Enables or disables the execute flag on the file. Can be true or false.
        @APIOption(key: "execute_filemode") public var fileMode: String?
        
        /// Name of the base branch to create the new branch from.
        @APIOption(key: "start_branch") public var startBranch: String?

        public init(branch: String,
                    commit: String,
                    content: String,
                    filePath: String,
                    project: DataTypes.ProjectID,
                    _ configure: ((CreateFile) -> Void)?) {
            super.init()
            self.project = project
            self.branch = branch
            self.content = content
            self.filePath = filePath
            configure?(self)
        }
        
    }

}

