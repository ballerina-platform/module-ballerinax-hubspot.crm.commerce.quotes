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
import ballerinax/hubspot.crm.commerce.quotes as quotes;

configurable string & readonly clientId = ?;
configurable string & readonly clientSecret = ?;
configurable string & readonly refreshToken = ?;

public function main() returns error? {
    
    quotes:OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    final quotes:Client storeClient = check new (config = {auth});

    string quoteId = "0";

    // Add new sales quote
    quotes:SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            "hs_title": "Premium Subscription Quote",
            "hs_expiration_date": "2025-02-28",
            "hs_currency": "USD"
        }
    };    
    var createdNewQuote = check storeClient->/.post(payload);
    quoteId = createdNewQuote.id;
    io:println(createdNewQuote);

    // Add a batch of quotes 
    quotes:SimplePublicObjectInputForCreate ob1 = {
        associations: [],
        properties: {
            "hs_title": "Quote 1", 
            "hs_expiration_date": "2025-02-28"
        }
    };

    quotes:SimplePublicObjectInputForCreate ob2 = {
        associations: [],
        properties: {
            "hs_title": "Quote 2", 
            "hs_expiration_date": "2025-04-30"
        }
    };

    quotes:BatchInputSimplePublicObjectInputForCreate batch_create_payload = {
        inputs: [ob1, ob2] 
    };

    // Call the Quotes API to create a new quote
    quotes:BatchResponseSimplePublicObject|quotes:BatchResponseSimplePublicObjectWithErrors createdQuotes = check storeClient->/batch/create.post(batch_create_payload);
    io:println(createdQuotes.results); 

    // Get all existing sales quotes
    quotes:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging allExistingQuotes = check storeClient->/.get();
    io:println(allExistingQuotes); 

    // Get one sales quote by ID
    quotes:SimplePublicObjectWithAssociations quote = check storeClient->/[quoteId].get();
    io:println(quote);

    // Get a batch of quotes
    quotes:SimplePublicObjectId ob0 = {
        id: quoteId 
    };

    quotes:BatchReadInputSimplePublicObjectId batch_get_payload = {
        properties: [],
        propertiesWithHistory: [], 
        inputs: [ob0]
    };

    quotes:BatchResponseSimplePublicObject|quotes:BatchResponseSimplePublicObjectWithErrors retrievedQuotes = check storeClient->/batch/read.post(batch_get_payload);

    io:println(retrievedQuotes.results);

    // Update one sales quote by ID
    quotes:SimplePublicObjectInput modifyPayload = {
        properties: {
            "hs_title": "Premium Subscription Quote",
            "hs_expiration_date": "2025-03-31",
            "hs_currency": "USD"
        }
    };
    quotes:SimplePublicObject modifiedQuote = check storeClient->/[quoteId].patch(modifyPayload);
    io:println(modifiedQuote); 

    // Update a batch of quotes
    quotes:SimplePublicObjectBatchInput ob3 = {
        id: quoteId,
        properties: {
            "hs_title": "Test Quote 3", 
            "hs_expiration_date": "2025-04-30"
        }
    };

    quotes:BatchInputSimplePublicObjectBatchInput batch_update_payload = {
        inputs: [ob3]
    };

    // Call the Quotes API to create a new quote
    quotes:BatchResponseSimplePublicObject|quotes:BatchResponseSimplePublicObjectWithErrors modifiedQuotes = check storeClient->/batch/update.post(batch_update_payload);
    io:println(modifiedQuotes.results); 

    // Archive one sales quote by ID
    http:Response archive_response = check storeClient->/[quoteId].delete(); 
    io:println(archive_response);

    // Archive a batch of quotes
    quotes:SimplePublicObjectId id0 = {id:"0"};

    quotes:BatchInputSimplePublicObjectId batch_archive_payload = {
        inputs:[
            id0 
        ]
    };

    http:Response batch_archive_response = check storeClient->/batch/archive.post(batch_archive_payload); 

    io:println(batch_archive_response); 
}
