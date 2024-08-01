## redborder-serverspec-proxy
Infrastructure integration testing for redborder-proxy

## Installation
On your workstation, execute the following command in your terminal:
```ssh
bundle install
```

## Running Tests
To run all tests, use the following command:
```
rake spec
```

Optional parameters:
* TARGET_HOST: Machine where the tests will run via SSH.
* LOGIN_USERNAME: Username for SSH connection to the test machine.
* LOGIN_PASSWORD: Password for SSH connection to the test machine.
Example with optional parameters:
```
TARGET_HOST="10.0.209.40" LOGIN_USERNAME="root" LOGIN_PASSWORD="redborder" rake spec
```

To run a specific test type, use the following command:
```
rake spec:configuration
```

To run a specific test in a spec file, better use tags:
```
rspec --tag tag_name
```

List of Available Rake Tasks:
To view the list of available Rake tasks, use the following command:
```
rake -T
```

Tag a describe to run by specific command ie:
```
describe ("Any test for this"), :tagname do
```
