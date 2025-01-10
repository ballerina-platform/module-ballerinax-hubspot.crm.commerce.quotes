# Ballerina HubSpot CRM Commerce Quotes connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.commerce.quotes.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.commerce.quotes)

## Overview

[HubSpot](https://www.hubspot.com/) is an customer platform with all the software, integrations, and resources users need to connect thier marketing, sales, and customer service.

The `ballerinax/hubspot.crm.commerce.quotes` package offers APIs to connect and interact with [HubSpot API for CRM Quotes](https://developers.hubspot.com/docs/reference/api/crm/commerce/quotes) endpoints, specifically based on [HubSpot CRM Quotes REST API](https://developers.hubspot.com/docs/reference/api).


## Setup guide

To use the HubSpot CRM Quotes connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore you need to register for a developer account at HubSpot if you don't have one already.

### Step 1: Create/Login to a HubSpot Developer Account

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

If you don't have a HubSpot Developer Account you can sign up to a free account [here](https://developers.hubspot.com/get-started)

### Step 2 (Optional): Create a [Developer Test Account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) under your account

Within app developer accounts, you can create developer test accounts to test apps and integrations without affecting any real HubSpot data.

>**Note:** These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts.

1. Go to Test Account section from the left sidebar. 

   ![Hubspot developer testacc1](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/create_developer_account_1.png)

2. Click Create developer test account.

   ![Hubspot developer testacc2](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/create_developer_account_2.png)

3. In the dialogue box, give a name to your test account and click create.

   ![Hubspot developer testacc3](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/create_developer_account_3.png)

### Step 3: Create a HubSpot App under your account.

1. In your developer account, navigate to the "Apps" section. Click on "Create App"

   ![Create account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/create_app.png)

2. Provide the necessary details, including the app name and description.

### Step 4: Configure the Authentication Flow.

1. Move to the Auth Tab.

   ![Authentication 1](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/authentication_1.png)

2. In the Scopes section, add the following scopes for your app using the "Add new scope" button.

   `crm.lists.read`
   `crm.lists.write`
   `cms.membership.access_groups.write`

   ![Authentication 2](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/authentication_2.png)

4. Add your Redirect URI in the relevant section. You can also use localhost addresses for local development purposes. Click Create App.

   ![Authentication 3](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/authentication_3.png)

### Step 5: Get your Client ID and Client Secret

- Navigate to the Auth section of your app. Make sure to save the provided Client ID and Client Secret.

   ![Client Id_& Client Secret](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/clientId_clientSecret.png)

### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

    **_NOTE: If you are using a localhost redirect url, make sure to have a listner running at the relevant port before executing the next step. You can use [this gist](https://gist.github.com/lnash94/0af47bfcb7cc1e3d59e06364b3c86b59) and run it using `bal run`. Alternatively, you can use any other method to bind a listner to the port._**

2. Paste it in the browser and select your developer test account to intall the app when prompted.

   ![Setup auth flow](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.quotes/blob/main/docs/setup/resources/setup_auth_flow.png)

3. A code will be displayed in the browser. Copy the code.

4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI`> and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token securely for use in your application.

## Quickstart

To use the `HubSpot CRM Quotes` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.commerce.quotes` module and `oauth2` module.

```ballerina
import ballerina/oauth2;
import ballerinax/hubspot.crm.commerce.quotes as crmquotes;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
   ```

2. Instantiate a `OAuth2RefreshTokenGrantConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina 
    configurable string clientId = ?;
    configurable string clientSecret = ?;
    configurable string refreshToken = ?;

    OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    final crmlists:Client crmListClient = check new (config = {auth});

    ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Create a CRM List
    
```ballerina

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

public function main() returns error? {
    final Client hubspotClient = check new (config = {auth});

    // Define the payload for creating a quote
    json payload = {
        "name": "Test Quote",
        "hs_expiration_date": "2025-12-31",
        "hs_status": "DRAFT",
        "hs_owner_id": "<owner-id>",
        "hs_currency": "USD",
        "hs_total_amount": 1500,
        "hs_associated_deal_id": "<deal-id>"
    };

    // Send the request to create a quote
    http:Response response = check hubspotClient->/crm/v3/objects/quotes.post(payload); 

    // Print the response
    io:println("Response: ", response.getJsonPayload());
}
```

## Examples

The `HubSpot CRM Commerce Quotes` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.commerce.quotes/examples/), covering the following use cases:

1. Sales Analytics System 

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.crm.commerce.quotes` package](https://central.ballerina.io/ballerinax/hubspot.crm.commerce.quotes/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
