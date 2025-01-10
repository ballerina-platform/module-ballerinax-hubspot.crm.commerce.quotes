## Sales Analytics System

A store can insert, update and delete their daily quotes in the system.
System records and analyses the data on the quotes, and user can get recorded data and analitics.

## Prerequisites

### 1. Setup Hubspot developer account

Refer to the [Setup guide](../../ballerina/Package.md#setup-guide) to obtain necessary credentials (client Id, client secret, refresh tokens).

### 2. Configuration

Create a `Config.toml` file in the example's root directory and, provide your Hubspot account related configurations as follows:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
credentialBearer =  "POST_BODY_BEARER"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```