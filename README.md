A command line tool to download web sites.

## Getting Started

### Requirements

- Ruby 3.2.2

### Installation

To install dependencies
```
bundle install
```

### Running tests

To run the tests
```
bundle exec rspec
```

### Usage

After installation, you can run `bin/fetch` along with the url of the sites you wish to fetch.

From example, the following command with create a file `www.google.com.html` containing the contents of the provided url.
```
bin/fetch https://www.google.com
```

It is possible to pass multiple urls.
```
bin/fetch https://www.google.com http://example.com
```

### Running in Docker

To use, first build the docker image.
```
docker build -t fetch .
```

Then run the following command and `www.google.com.html` will be created in your current directory.
```
docker run --rm -v ${PWD}:/usr/src/app/ --net=host fetch https://www.google.com
```

Multiple urls can be supplied like so.
```
docker run --rm -v ${PWD}:/usr/src/app/ --net=host fetch https://www.google.com http://example.com/
```
## Design

### Decisions

#### Railway Orient Programming:
Services are created with a list of operations with a defined order. As each operation returns a result object we can check if it was a success or failure before proceeding to the next operation. This way there is only one happy path and multiple unhappy paths, and as the service always returns a result object we can expect how to handle each case. Knowing the point of failure also makes communicating to the user easier.
The main benefit of this design is the ease of extension, if requirements change we only need to add a new operation at the logical point and adjust the following operation to accept the new value.
The downsides seem to be performance may suffer compared to an object oriented design as we cannot "exit early", we must evaluate if we can run each operation.

#### Docker
Alpine is used as we are aiming for a small docker image. I decided to add Ruby to the image instead of using an official image as it lead to decrease in final image size by about 300MB, down to 45MB. I am sure I am not removing all the cruft, but that could optimized when it becomes an issue. The cost of not using an official image may be felt when adding new gems in the future. Gems may require dependencies or build tools not present in the image, requiring the developers to adjust the Dockerfile to ensure the build can be completed.

#### Testing
I have a lot of experience with RSpec so it is my go to testing framework. I have included VCR and Webmock to mock network calls. That way the test suite does not need a network connection, nor should the test suite rely on outside services. It is also as a courtesy to site owners, as it would be rude to connect every time a test is run.

### What I would like to do
- Use [FakeFS](https://github.com/fakefs/fakefs) to avoid writing and cleaning up files during testing
- Download images and css for fetched website
