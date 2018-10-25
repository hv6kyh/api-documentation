# API Reference

The Deepomatic API is organized around REST. Our API has predictable, resource-oriented URLs, and uses HTTP response codes to indicate API errors. We use built-in HTTP features, like HTTP authentication and HTTP verbs, which are understood by off-the-shelf HTTP clients. We support cross-origin resource sharing, allowing you to interact securely with our API from a client-side web application (though you should never expose your secret admin API key in any public website's client-side code). JSON is returned by all API responses, including errors, although our API libraries convert responses to appropriate language-specific objects.

**IMPORTANT**: The API only allow to send data with a Content-Type "application/json" or "multipart/form-data". If you try to send "application/x-www-form-urlencoded" you will receive a 415 status code.


> <span class="h1">API clients</span>

> Deepomatic API currently has one supported [client in python](https://github.com/Deepomatic/deepomatic-client-python).


> API Endpoint

```shell
{{ VULCAIN_URL }}/{{ VERSION }}
```
