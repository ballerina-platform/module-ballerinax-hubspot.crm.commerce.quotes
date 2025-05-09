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

import ballerina/oauth2;
import ballerina/test;

configurable string clientId = "clientId";
configurable string clientSecret = "clientSecret";
configurable string refreshToken = "refreshToken";
configurable boolean enableLiveServerTest = false;

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final Client hubspotClient = check new ({
    auth: enableLiveServerTest ? auth
        : {token: "test-token"}
});

string testQuoteId = "";

// Test function for creating a quote
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testCreateNewQuote() returns error? {
    SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            "hs_title": "Test Quote",
            "hs_expiration_date": "2025-01-31"
        }
    };

    // Call the Quotes API to create a new quote
    SimplePublicObject response = check hubspotClient->/.post(payload);

    // Set test id
    testQuoteId = response.id;

    // Validate the response
    test:assertEquals(response.properties["hs_title"], "Test Quote",
            "New quote not created successfully.");

}

// Test function for creating a batch of quotes
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testCreateNewBatchOfQuotes() returns error? {

    SimplePublicObjectInputForCreate batchInput1 = {
        associations: [],
        properties: {
            "hs_title": "Test Quote 1",
            "hs_expiration_date": "2025-02-28"
        }
    };

    SimplePublicObjectInputForCreate batchInput2 = {
        associations: [],
        properties: {
            "hs_title": "Test Quote 2",
            "hs_expiration_date": "2025-04-30"
        }
    };

    BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [batchInput1, batchInput2]
    };

    // Call the Quotes API to create a new quote
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/create.post(payload);

    // Validate the response
    test:assertEquals(response.results.length(), payload.inputs.length(),
            "New batch of quotes not created successfully.");

}

// Test for retrieving all quotes
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testGetAllQuotes() returns error? {

    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspotClient->/.get();

    test:assertTrue(response.results.length() > 0,
            msg = "No quotes found in the response.");
}

// Test function for retrieving a quote
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testGetOneQuote() returns error? {
    SimplePublicObjectWithAssociations response = check hubspotClient->/[testQuoteId].get();

    test:assertEquals(response.id, testQuoteId, "Quote ID is missing.");
}

// Test function for retrieving a batch of quotes 
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testGetBatchOfQuotes() returns error? {

    SimplePublicObjectId batchInput0 = {
        id: testQuoteId
    };

    BatchReadInputSimplePublicObjectId payload = {
        properties: [],
        propertiesWithHistory: [],
        inputs: [batchInput0]
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/read.post(payload);

    // Validate essential fields
    test:assertEquals(response.results.length(), payload.inputs.length(), msg = string `Only ${response.results.length()} IDs found.`);
}

// Archive a quote by ID
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testArchiveOneQuote() returns error? {

    error? response = hubspotClient->/["0"].delete();

    test:assertTrue(response == ());
}

// Archive batch of quotes by ID
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testArchiveBatchOfQuoteById() returns error? {

    SimplePublicObjectId id0 = {id: "0"};

    BatchInputSimplePublicObjectId payload = {
        inputs: [
            id0
        ]
    };

    error? response = hubspotClient->/batch/archive.post(payload);

    test:assertTrue(response == ());
}

// Test function for updating a quote
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testUpdateOneQuote() returns error? {
    SimplePublicObjectInput payload = {
        properties: {
            "hs_title": "Test Quote Modified",
            "hs_expiration_date": "2025-03-31"
        }
    };

    // Call the Quotes API to update the quote
    SimplePublicObject response = check hubspotClient->/[testQuoteId].patch(payload);

    test:assertEquals(response.properties["hs_title"], "Test Quote Modified",
            "Quote not updated successfully.");
}

// Test function for updating a batch of quotes
@test:Config {
    groups: ["live_tests"],
    enable: enableLiveServerTest
}
function testUpdateBatchOfQuotes() returns error? {

    SimplePublicObjectBatchInput batchInput3 = {
        id: testQuoteId,
        properties: {
            "hs_title": "Test Quote 3",
            "hs_expiration_date": "2025-04-30"
        }
    };

    BatchInputSimplePublicObjectBatchInput payload = {
        inputs: [batchInput3]
    };

    // Call the Quotes API to create a new quote
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/update.post(payload);

    test:assertEquals(response.results.length(), payload.inputs.length(),
            "Quote in response does not match the expected quote.");
}

