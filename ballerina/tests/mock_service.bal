// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new(9090);

http:Service mockService = service object {
    
    // Archive
    resource function delete crm/v3/objects/quotes/[string quoteId]() returns http:Response|error {
        http:Response response = new();
        response.statusCode = http:STATUS_NO_CONTENT;
        response.setPayload("Successfully deleted");
        return response;
    }

    // Read
    resource function get crm/v3/objects/quotes/[string quoteId](string[]? properties, string[]? propertiesWithHistory, string[]? associations, string? idProperty, boolean archived = false) returns SimplePublicObjectWithAssociations|error {
        return {
            id: "0",
            properties: {
                "hs_title": "Test Quote 0", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        };
    }

    // Update
    resource function patch crm/v3/objects/quotes/[string quoteId](string? idProperty, @http:Payload SimplePublicObjectInput payload) returns SimplePublicObject|error {
        return {
            id: "1",
            properties: {
                "hs_title": "Test Quote 1", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        }; 
    }

    // Create
    resource function post crm/v3/objects/quotes(@http:Payload SimplePublicObjectInputForCreate payload) returns SimplePublicObject|error {
        return {
            id: "2",
            properties: {
                "hs_title": "Test Quote 2", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        }; 
    }

    resource function post crm/v3/objects/quotes/batch/upsert(@http:Payload BatchInputSimplePublicObjectBatchInputUpsert payload, map<string|string[]> headers = {}) returns BatchResponseSimplePublicUpsertObject|error {
        SimplePublicUpsertObject ob1 = {
                    id: "1",
                    properties: {
                        "hs_title": "Test Quote 1", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    'new: true,
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                };
        SimplePublicUpsertObject ob2 = {
                    id: "2",
                    properties: {
                        "hs_title": "Test Quote 2", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    'new: true,
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                };
        return {
            completedAt: "2025-01-10",
            startedAt: "2025-01-08",
            requestedAt: "2025-01-08",
            results:[ob1,ob2],
            status: "COMPLETE"
        };
    }

    resource isolated function post crm/v3/objects/quotes/search(@http:Payload PublicObjectSearchRequest payload, map<string|string[]> headers = {}) returns CollectionResponseWithTotalSimplePublicObjectForwardPaging|error {
        SimplePublicObject ob1 = {
                    id: "1",
                    properties: {
                        "hs_title": "Test Quote 1", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                };
        SimplePublicObject ob2 = {
                    id: "2",
                    properties: {
                        "hs_title": "Test Quote 2", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                };
        return {
            total: 1500,
            results: [ob1, ob2] 
        };
    }
};

function init() returns error?{
    log:printInfo("Initializing mock service");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}