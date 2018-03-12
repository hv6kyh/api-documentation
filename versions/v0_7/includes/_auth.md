# Authentication

To access the API, you will need an APP-ID and an API-KEY. Please login on [https://developers.deepomatic.com/dashboard#/account](/dashboard#/account) to retrieve your credentials. Make sure you use the adequate credentials.

<aside class="notice">
The "Read" key gives access to endpoints finishing by "/inference". The "Admin" gives access to all API endpoints.
</aside>

Authentication is done via HTTP headers. The X-APP-ID header identifies which application you are accessing, and the X-API-KEY header authenticates the endpoint.

> To check your credentials work, you can run:

```shell--curl
curl -s {{ VULCAIN_URL }}/{{ VERSION }}/accounts/me \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

print(client.Account.retrieve('me'))
```



