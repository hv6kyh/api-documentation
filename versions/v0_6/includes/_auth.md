# Authentication

To access the API, you will need an APP-ID and an API-KEY. Please login on [https://developers.deepomatic.com/credentials](/credentials) to retrieve your credentials. Make sure you use the adequate credentials.

<aside class="notice">
The "Read" key is for read only purpose (e.g. classify/detect/search). The "Admin" key is for more advanced purposes (e.g. changing networks, indexing images).
</aside>

```shell
curl "{{ VULCAIN_URL }}/{{ VERSION }}/..." -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" ...
```

Authentication is done via HTTP headers. The X-APP-ID header identifies which application you are accessing, and the X-API-KEY header authenticates the endpoint.

