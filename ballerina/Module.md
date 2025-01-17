## Overview

[HubSpot](https://www.hubspot.com) is an AI-powered customer relationship management (CRM) platform.

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

1. Create an authorization URL using the following format.

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

The `HubSpot CRM Commerce Quotes` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.commerce.quotes/tree/main/examples/), covering the following use cases:

