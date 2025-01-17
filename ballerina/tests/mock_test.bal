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
import ballerina/test;

final Client quotesClient = check new(config = {auth:{
    token: "test-token"
}}, serviceUrl="http://localhost:9090/crm/v3/objects/quotes"
);

// Test function for creating a quote
@test:Config{}
function testCreateAQuote() returns error? {
    SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            "hs_title": "Test Quote 2", 
            "hs_expiration_date": "2025-01-31"
        }
    };

    SimplePublicObject response = check quotesClient->/.post(payload);

    test:assertEquals(response.properties["hs_title"], payload.properties["hs_title"], "New quote creation failed.");     
}

// Test function to get a quote bu ID
@test:Config{}
function testGetAQuoteById() returns error? {
    SimplePublicObjectWithAssociations response = check quotesClient->/["0"].get();

    SimplePublicObjectWithAssociations expectedQuote = {
            id: "0",
            properties: {
                "hs_title": "Test Quote 0", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        };

    test:assertEquals(response, expectedQuote, "Reading this quote is failed.");
}

// Test function to archive a quote by ID 
@test:Config{}
function testArchiveAQuoteById() returns error?{

    http:Response response = check quotesClient->/["0"].delete(); 

    test:assertTrue(response.statusCode == 204);
}

// Test function to update a quote
@test:Config{}
function testUpdateAQuoteById() returns error? {
    SimplePublicObjectInput payload = {
        properties: {
            "hs_title": "Test Quote 1", 
            "hs_expiration_date": "2025-01-31"
        }
    };

    // Call the Quotes API to update the quote
    SimplePublicObject response = check quotesClient->/["1"].patch(payload);

    SimplePublicObject updatedQuote = {
            id: "1",
            properties: {
                "hs_title": "Test Quote 1", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        };

    test:assertEquals(response, updatedQuote, "Quote update failed.");
}

// Test function to upsert a quote
@test:Config{}
function testUpsertAQuote() returns error? {
    BatchInputSimplePublicObjectBatchInputUpsert payload = {
        inputs: [
            {
                id: "1",
                properties: {
                    "hs_title": "Test Quote 1", 
                    "hs_expiration_date": "2025-01-31"
                }
            },
            {
                id: "2",
                properties: {
                    "hs_title": "Test Quote 2", 
                    "hs_expiration_date": "2025-03-31"
                }
            }
        ]
    };

    BatchResponseSimplePublicUpsertObject response = check quotesClient->/batch/upsert.post(payload = payload);

    BatchResponseSimplePublicUpsertObject expectedBatch = {
            completedAt: "2025-01-10",
            startedAt: "2025-01-08",
            requestedAt: "2025-01-08",
            results:[
                {
                    id: "1",
                    properties: {
                        "hs_title": "Test Quote 1", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    'new: true,
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                },
                {
                    id: "2",
                    properties: {
                        "hs_title": "Test Quote 2", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    'new: true,
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                }
            ],
            status: "COMPLETE"
        };

    test:assertEquals(response, expectedBatch, "Quote upsert failed.");
}

// Test function to upsert a quote
@test:Config{}
function testSearchAQuote() returns error? {
    
    PublicObjectSearchRequest payload = {
    filterGroups: [
        {
            filters: [
                {
                    propertyName: "hs_title",
                    operator: "EQ",
                    value: "Test Quote 1"
                }
            ]
        }
    ],
    properties: ["hs_title", "hs_expiration_date"]
};

    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check quotesClient->/search.post(payload = payload);

    SimplePublicObject batchOutput1 = {
                    id: "1",
                    properties: {
                        "hs_title": "Test Quote 1", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                };
    SimplePublicObject batchOutput2 = {
                    id: "2",
                    properties: {
                        "hs_title": "Test Quote 2", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                };

    test:assertEquals(response, {
            total: 1500,
            results: [batchOutput1, batchOutput2] 
        }, "Quote search failed."); 
}
