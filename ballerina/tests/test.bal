import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerina/test;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final string serviceUrl = "https://api.hubapi.com/crm/v3/objects/quotes";

final Client hubspotClient = check new Client(config = {auth}, serviceUrl = serviceUrl);

string testQuoteId = ""; 


// Test function for creating a quote
@test:Config{}
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
    test:assertTrue(response.id != "");
      
}


// Test function for creating a batch of quotes
@test:Config{}
function testCreateNewBatchOfQuotes() returns error? {

    SimplePublicObjectInputForCreate ob1 = {
        associations: [],
        properties: {
            "hs_title": "Test Quote 1", 
            "hs_expiration_date": "2025-02-28"
        }
    };

    SimplePublicObjectInputForCreate ob2 = {
        associations: [],
        properties: {
            "hs_title": "Test Quote 2", 
            "hs_expiration_date": "2025-04-30"
        }
    };

    BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [ob1, ob2] 
    };

    // Call the Quotes API to create a new quote
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/create.post(payload);

    // Validate the response
    test:assertTrue(response.results.length() > 0); 
      
}


// Test for retrieving all quotes
@test:Config{}
function testGetAllQuotes() returns error? {

    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error response = check hubspotClient->/.get();

    // Validate the response contains a list of quotes
    if(response is CollectionResponseSimplePublicObjectWithAssociationsForwardPaging){
        test:assertTrue(response.results.length() > 0, 
            msg = "No quotes found in the response."); 
    }else {
        io:println(response);
    }
}

// Test function for retrieving a quote
@test:Config{}
function testGetOneQuote() returns error? {
    SimplePublicObjectWithAssociations|error response = check hubspotClient->/[testQuoteId].get();

    if (response is SimplePublicObjectWithAssociations) {
        // Validate essential fields
        test:assertTrue(response.id == testQuoteId, msg = "Quote ID is missing.");
    } else if (response is error) {
        test:assertFail("Failed to retrieve quote: " + response.message());
    }
}

// Test function for retrieving a batch of quotes 
@test:Config{}
function testGetBatchOfQuotes() returns error? {

    SimplePublicObjectId ob0 = {
        id: testQuoteId 
    };

    BatchReadInputSimplePublicObjectId payload = {
        properties: [],
        propertiesWithHistory: [], 
        inputs: [ob0]
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/read.post(payload);

    // Validate essential fields
    test:assertTrue(response.results.length() == payload.inputs.length(), msg = string`Only ${response.results.length()} IDs found.`);
}


// Archive a quote by ID
@test:Config{}
function testArchiveOneQuote() returns error?{

    http:Response|error response = check hubspotClient->/["0"].delete(); 

    // Validate the response
    if(response is http:Response){
        test:assertTrue(response.statusCode == 204);
    }else{
        test:assertFail("Deletion failed."); 
    }
}

// Archive batch of quotes by ID
@test:Config{}
function testArchiveBatchOfQuoteById() returns error?{

    SimplePublicObjectId id0 = {id:"0"};

    BatchInputSimplePublicObjectId payload = {
        inputs:[
            id0 
        ]
    };

    http:Response|error response = check hubspotClient->/batch/archive.post(payload); 

    // Validate the response
    if(response is http:Response){
        test:assertTrue(response.statusCode == 204);
    }else{
        test:assertFail("Deletion failed."); 
    }
}


// Test function for updating a quote
@test:Config{}
function testUpdateOneQuote() returns error? {
    SimplePublicObjectInput payload = {
        properties: {
            "hs_title": "Test Quote Modified",
            "hs_expiration_date": "2025-03-31" 
        }
    };

    // Call the Quotes API to update the quote
    SimplePublicObject|error response = check hubspotClient->/[testQuoteId].patch(payload);

    // Validate the response
    if(response is SimplePublicObject){
        test:assertTrue(response.id != "", 
        msg = "Quote in response does not match the expected quote."); 
    }else {
        io:println(response); 
    }
}

// Test function for updating a batch of quotes
@test:Config{}
function testUpdateBatchOfQuotes() returns error? {

    SimplePublicObjectBatchInput ob3 = {
        id: testQuoteId,
        properties: {
            "hs_title": "Test Quote 3", 
            "hs_expiration_date": "2025-04-30"
        }
    };

    BatchInputSimplePublicObjectBatchInput payload = {
        inputs: [ob3]
    };

    // Call the Quotes API to create a new quote
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response = hubspotClient->/batch/update.post(payload);

    // Validate the response
    if(response is BatchResponseSimplePublicObject){
        test:assertTrue(response.results.length() == payload.inputs.length(), 
        msg = "Quote in response does not match the expected quote."); 
    }else{
        test:assertFail("Errors in updating.");
    }
}

// // Test function for creating or updating a batch of quotes
// @test:Config{}
// function testCreateOrUpdateBatchOfQuotes() returns error? {

//     SimplePublicObjectBatchInputUpsert ob4 = {
//         id: testQuoteId,
//         properties: {
//             "hs_title": "Test Quote 4", 
//             "hs_expiration_date": "2025-05-31"
//         }
//     };

//     BatchInputSimplePublicObjectBatchInputUpsert payload = {
//         inputs: [ob4] 
//     };

//     // Call the Quotes API to create a new quote
//     BatchResponseSimplePublicUpsertObject|BatchResponseSimplePublicUpsertObjectWithErrors|error response = hubspotClient->/batch/upsert.post(payload);

//     // Validate the response
//     if(response is BatchResponseSimplePublicUpsertObject){
//         test:assertTrue(response.results.length() == payload.inputs.length(), 
//         msg = "Quote in response does not match the expected quote."); 
//     }else{
//         test:assertFail("Errors in updating.");
//     }
// }
