A command line tool to download web sites.

## Running in Docker

To use, first build the docker image.
```
docker build -t fetch .
```

Then run the following command and 'www.google.com.html` will be created in your current directory.
```
docker run --rm -v ${PWD}:/usr/src/app/ --net=host fetch https://www.google.com
```

Multiple urls can be supplied like so.
```
docker run --rm -v ${PWD}:/usr/src/app/ --net=host fetch https://www.google.com http://example.com/
```
