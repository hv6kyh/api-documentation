# Search

## <a name="contact_us">Contact us</a>

The Search Engine is currently unavailable to the public. If you are interested please contact us at support@deepomatic.com

<br/>
<br/>
<br/>
<br/>


<!---

<a name="indexed_object_object"></a>
## Indexed objects

> ### Example of indexed object

```json
{
    "id": "123-fr",
    "db": "my_db",
    "imgs": [
        {
            "url": "http://www.petmd.com/sites/default/files/what-does-it-mean-when-cat-wags-tail.jpg",
            "bbox": {
                "xmin": 0.10677965730428696,
                "ymin": 0.0,
                "xmax": 0.801694929599762,
                "ymax": 0.9999999403953552
            },
            "polygon": null,
            "width": 410,
            "height": 428
        }
    ],
    "data": {},
    "date_updated": "2017-05-11T09:02:01.746000Z"
}
```

An object that is stored in DB and ready for being visually searchable.

Attribute | Type    | Description
--------- | ------- | ------------
id        | string  | The object ID.
db        | string  | The database where it is stored.
imgs      | array(object) | An array of [indexed images](#indexed_images_object).
date_updated | string | The last time this object was modified.
data      | object  | Reserved for user, this field is free of specifications.













## Getting Started

### Create a database

> ### Example of Request to Create an Object

```json
{
    "imgs" : [
        "url" : "my_url",
        "base64" : "my_b64_encoded_image",
        "bbox" : {"xmin": 0, "ymin": 0.5, "xmax": 1, "ymax": 1},
        "polygon" : [{"x": 1, "y": 0.5}, {"x": 1, "y": 1}, {"x": 0.5, "y": 1}]
    ],
    "data" : {"my_field" : "my_data"}
}
```

> ### Example of Response

```json
{
    "db"      : "my_db",
    "id"      : "foo",
    "task_id" : 1234
}
```

First thing to do to get started is to create a database with your images to work with.
In order to do so, you just have to add an object to the database you want to create and it will automatically be create.

### Create an object

To create an object you have two options :

- Create one with with an auto-assigned ID by calling this end point :

    ```POST /{{ VERSION }}/search/dbs/{db_name}/objects/```

- Create one with your own ID with this endpoint :

     ```PUT /{{ VERSION }}/search/dbs/{db_name}/objects/{object_id}/```

Both take the same request body.

You can't have the field ```"url"``` and the field ```"base64"``` at the same time.

The ```data``` field allow you to add your own fields to an object, you must send a valid dictionnary.
When you perform a similarity search or just when you get an object from the database, you will retrive this field with your data.

You can find more details on each field on the "Object related operations" section.


**Caution** : If the url takes too much time to respond, the request will time out.

### Perform a similarity search

> ### Example of Request to Perform a Similarity Search

```json
{
    "url" : "my_url",
    "base64" : "my_b64_encoded_image",
    "bbox" : {"xmin": 0, "ymin": 0.5, "xmax": 1, "ymax": 1},
    "polygon" : [{"x": 1, "y": 0.5}, {"x": 1, "y": 1}, {"x": 0.5, "y": 1}],
    "updated_before" : "YYYY-MM-DD",
    "updated_after" : "YYYY-MM-DD",
    "fields" : "fields_to_be_return",
    "limit" : 100,
    "skip" : 2,
    "filters" : {"my_field" : "value"}
}
```

> ### Example of Response

```json
{
    "task_id" : 1234,
    "status" : "success",
    "data" : {
        "hits" : [{
            "data" : {
                "myfield" : "foo"
            },
            "date_updated" : "YYYY-MM-DD",
            "db" : "my_db",
            "id" : "foo",
            "imgs" : [
                "url" : "my_url",
                "base64" : "my_b64_encoded_image",
                "bbox" : {"xmin": 0, "ymin": 0.5, "xmax": 1, "ymax": 1},
                "polygon" : [{"x": 1, "y": 0.5}, {"x": 1, "y": 1}, {"x": 0.5, "y": 1}],
                "score" : 0.8
            ]
        }]
        "limit" : 100,
        "skip"  : 0
    }
}
```

If you want to perform a similarity search among images in a database, you have to send a request to :
    ```GET /{{ VERSION }}/search/query/{db_name}/```


You must have a field ```"url"``` or a field ```base64``` but you can't have them at the same time, all other fields are optional.


You can find more details on each field on the "Searching your databases" section.

#### Response
The api will send you a task id.
```
{
    "task_id" : 1234
}
```

You can check the task status when you want to see if the task as complete.
```
{
    "task_id" : 1234,
    "status" : "pending"
}
```

Once ```"status"``` is set to ```"success"```, you can get the response from the api in the ```"data"``` field.
















<a name="create_db_object"></a>
## Create an object

> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/search/dbs/{:db}/objects```
```PUT  {{ VULCAIN_URL }}/{{ VERSION }}/search/dbs/{:db}/objects/{:id}```

> ### Example Request

```shell
$ curl -XPOST "{{ VULCAIN_URL }}/{{ VERSION }}/search/dbs/{:db}/objects" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

Create an searchable object. This object may have multiple images (e.g. with different point of views). The first endpoint (POST) creates an object with a auto-assigned ID, the second endpoint (PUT) creates an object with a user specified ID.

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
db        | string  |         | The database name where to store the object. The database is create if it does not exists.
id        | string  |         | User specified ID for the object. Alphanumerical characters as well as "_" and "-" are allowed.
imgs      | array   |         | An array of [image objects](#image_object). Must not be empty.
data      | object  |         | Reserved for user, this field is free of specifications.

If no `bbox` field is specified for images of the `imgs` field, a bounding box will be estimated by trying to estimate uniform background.

### Response

Returns the database name, object ID and task ID related to image indexing.

Attribute | Type    | Description
--------- | ------- | -----------
db        | string  | The database where it is stored.
id        | string  | The object ID.
task_id   | string  | The task ID related to indexing the object.

















## Update an object

> ### Definition
```PUT/PATCH  {{ VULCAIN_URL }}/{{ VERSION }}/search/dbs/{:db}/objects/{:id}```

Use PUT version to update an object with new `imgs` and new `data`.
Use PATCH version to update either `imgs` or `data`.
Please refer to [Create an object](#create_db_object) for further format definition.












## Get an object

> ### Definition
```GET  {{ VULCAIN_URL }}/{{ VERSION }}/search/dbs/{:db}/objects/{:id}```

> ### Example Request

```shell
$ curl "{{ VULCAIN_URL }}/{{ VERSION }}/search/dbs/my_db/objects/123-fr" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

> ### Example Response

```json
{
    "object": {
        "id": "123-fr",
        "db": "my_db",
        "imgs": [
            {
                "url": "http://www.petmd.com/sites/default/files/what-does-it-mean-when-cat-wags-tail.jpg",
                "bbox": {
                    "xmin": 0.10677965730428696,
                    "ymin": 0.0,
                    "xmax": 0.801694929599762,
                    "ymax": 0.9999999403953552
                },
                "polygon": null,
                "width": 410,
                "height": 428
            }
        ],
        "data": {},
        "date_updated": "2017-05-11T09:02:01.746000Z"
    }
}
```

Get a specific object.

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
db        | string  | The database where it is stored.
id        | string  | The object ID.

### Response

Attribute | Type    | Description
--------- | ------- | -----------
object    | object  | An [indexed object](#indexed_object_object).



-->