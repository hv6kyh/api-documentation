## API documentation

This is the [documentation for deepomatic's API](https://developers.deepomatic.com/docs/v0.7).

## Acknowledgment

This documentation was created using [Slate](https://github.com/lord/slate).

## Contributing

Contribution is welcome if you see a typo or error !
Documentation is written in MarkDown and its current version can be found in: [versions/v0_7/includes](versions/v0_7/includes).

## How to run ?

First, launch dmake with:

```
$ dmake shell doc
```

Then, just launch Middleman with:

```
$ make
```

Middleman automatically reloads the source when you modify it so no need to reload it by hand (except if you change [config.rb](config.rb)).

You can then view the doc by visiting [http://localhost:8000](http://localhost:8000) (adapt the port number if necessary by running `docker ps --format "table {{.Ports}}\t{{.Names}}" | grep api-documentation`)

