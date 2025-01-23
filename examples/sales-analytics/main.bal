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
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.commerce.quotes as hsQuotes;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

public function main() returns error? {
    
    hsQuotes:OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    final hsQuotes:Client storeClient = check new ({auth});

    // Add new sales quote
    hsQuotes:SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            "hs_title": "Premium Subscription Quote",
            "hs_expiration_date": "2025-02-28",
            "hs_currency": "USD"
        }
    };    
    var createdNewQuote = check storeClient->/.post(payload);
    string quoteId = createdNewQuote.id;
    io:println(createdNewQuote);

    // Add a batch of quotes 
    hsQuotes:SimplePublicObjectInputForCreate batchInput1 = {
        associations: [],
        properties: {
            "hs_title": "Quote 1", 
            "hs_expiration_date": "2025-02-28"
        }
    };
    hsQuotes:SimplePublicObjectInputForCreate batchInput2 = {
        associations: [],
        properties: {
            "hs_title": "Quote 2", 
            "hs_expiration_date": "2025-04-30"
        }
    };
    hsQuotes:BatchInputSimplePublicObjectInputForCreate batchCreatePayload = {
        inputs: [batchInput1, batchInput2] 
    };

    // Call the Quotes API to create a new quote
    hsQuotes:BatchResponseSimplePublicObject|hsQuotes:BatchResponseSimplePublicObjectWithErrors createdQuotes = check storeClient->/batch/create.post(batchCreatePayload);
    io:println(createdQuotes.results); 

    // Get all existing sales quotes
    hsQuotes:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging allExistingQuotes = check storeClient->/.get();
    io:println(allExistingQuotes); 

    // Get one sales quote by ID
    hsQuotes:SimplePublicObjectWithAssociations quote = check storeClient->/[quoteId].get();
    io:println(quote);

    // Get a batch of quotes
    hsQuotes:SimplePublicObjectId ob0 = {
        id: quoteId 
    };
    hsQuotes:BatchReadInputSimplePublicObjectId batchGetPayload = {
        properties: [],
        propertiesWithHistory: [], 
        inputs: [ob0]
    };
    hsQuotes:BatchResponseSimplePublicObject|hsQuotes:BatchResponseSimplePublicObjectWithErrors retrievedQuotes = check storeClient->/batch/read.post(batchGetPayload);
    io:println(retrievedQuotes.results);

    // Update one sales quote by ID
    hsQuotes:SimplePublicObjectInput modifyPayload = {
        properties: {
            "hs_title": "Premium Subscription Quote",
            "hs_expiration_date": "2025-03-31",
            "hs_currency": "USD"
        }
    };
    hsQuotes:SimplePublicObject modifiedQuote = check storeClient->/[quoteId].patch(modifyPayload);
    io:println(modifiedQuote); 

    // Update a batch of quotes
    hsQuotes:SimplePublicObjectBatchInput batchInput3 = {
        id: quoteId,
        properties: {
            "hs_title": "Test Quote 3", 
            "hs_expiration_date": "2025-04-30"
        }
    };
    hsQuotes:BatchInputSimplePublicObjectBatchInput batchUpdatePayload = {
        inputs: [batchInput3]
    };

    // Call the Quotes API to create a new quote
    hsQuotes:BatchResponseSimplePublicObject|hsQuotes:BatchResponseSimplePublicObjectWithErrors modifiedQuotes = check storeClient->/batch/update.post(batchUpdatePayload);
    io:println(modifiedQuotes.results); 

    // Archive one sales quote by ID
    http:Response archive_response = check storeClient->/[quoteId].delete(); 
    io:println(archive_response);

    // Archive a batch of quotes
    hsQuotes:SimplePublicObjectId id0 = {id:"0"};
    hsQuotes:BatchInputSimplePublicObjectId batchArchivePayload = {
        inputs:[
            id0 
        ]
    };
    http:Response batchArchiveResponse = check storeClient->/batch/archive.post(batchArchivePayload); 
    io:println(batchArchiveResponse); 
}
