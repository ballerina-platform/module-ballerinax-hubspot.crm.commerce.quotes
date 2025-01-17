# Examples

The `ballerinax/hubspot.crm.commerce.quotes` connector provides practical examples illustrating usage in various scenarios.

1. [Sales Analytics System](./sales_analytics/) - A store can insert their quotes to the system, and system record and analyses the details on the quotes. 

## Prerequisites

1. Generate HubSpot credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/twitter/latest#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Below is an example of how your `Config.toml` file should be structured:

    ```toml
    [auth]
    clientId = "<Client Id>"
    clientSecret =  "<Client Secret>"
    refreshToken = "<Refresh Token>"
    credentialBearer =  "POST_BODY_BEARER"

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
