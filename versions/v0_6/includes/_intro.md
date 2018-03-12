# API Reference

>
### API libraries
Official libraries for the Deepomatic API are [available in several languages](https://github.com/Deepomatic).
### API Endpoint
{{ VULCAIN_URL }}/{{ VERSION }}

The Deepomatic API is organized around REST. Our API has predictable, resource-oriented URLs, and uses HTTP response codes to indicate API errors. We use built-in HTTP features, like HTTP authentication and HTTP verbs, which are understood by off-the-shelf HTTP clients. We support cross-origin resource sharing, allowing you to interact securely with our API from a client-side web application (though you should never expose your secret admin API key in any public website's client-side code). JSON is returned by all API responses, including errors, although our API libraries convert responses to appropriate language-specific objects.

### Deepomatic API clients

We have wrote clients in the following languages:
- [JS](https://github.com/Deepomatic/deepomatic-client-js)
- [Python](https://github.com/Deepomatic/deepomatic-client-python)
- [Ruby](https://github.com/Deepomatic/deepomatic-client-ruby)
- [PHP](https://github.com/Deepomatic/deepomatic-client-php)

Please refer to the documentation of each client.