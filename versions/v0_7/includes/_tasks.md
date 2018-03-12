# Tasks





<a name="task_object"></a>
## The task object

Some endpoints do not return a direct response. Instead they return a `task_id` which will contain the results once ready.
In most cases you will need to [get the task](#get_task_status) until the status is not "pending". The status will then either be:

- "success": in which case you can read the `data` field to access the expected response.
- "error": in which case the `error` field will contain an error message and the `data` field will be null.

Attribute | Type    | Description
--------- | ------- | -----------
id        | string  | The task ID
status    | string  | The task status, either `"pending"`, `"success"`, or `"error"
error     | string  | Defined in case of error, it is the error message
date_created | string | The creation data timestamp
date_updated | string | The timestamp where status switched from "pending" to another status
data      | object  | The response JSON of the endpoint that generated the task


> Example of task object

```json
{
    "id": "269999729",
    "status": "success",
    "error": null,
    "date_created": "2018-03-10T20:38:12.818792Z",
    "date_updated": "2018-03-10T20:38:13.032942Z",
    "data": {
        "outputs": [
            {
                "labels": {
                    "discarded": [],
                    "predicted": [
                        {
                            "threshold": 0.025,
                            "label_id": 207,
                            "score": 0.952849746,
                            "label_name": "golden retriever"
                        }
                    ]
                }
            }
        ]
    },
    "subtasks": null
}
```























<a name="get_task_status"></a>
## Get task status

This endpoint retrieves the state of a given task.

> Definition

```shell--curl
GET {{ VULCAIN_URL }}/{{ VERSION }}/tasks/{TASK_ID}
```

```python--Python
client.Task.retrieve({TASK_ID})
```

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
task_id   | string  |         | The task ID


> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/tasks/269999729 \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

client.Task.retrieve(269999729)
```

### Response

It returns a [task object](#task_object).

> Example Response

```json
{
    "id": "269999729",
    "status": "success",
    "error": null,
    "date_created": "2018-03-10T20:38:12.818792Z",
    "date_updated": "2018-03-10T20:38:13.032942Z",
    "data": {
        "outputs": [
            {
                "labels": {
                    "discarded": [],
                    "predicted": [
                        {
                            "threshold": 0.025,
                            "label_id": 207,
                            "score": 0.952849746,
                            "label_name": "golden retriever"
                        }
                    ]
                }
            }
        ]
    },
    "subtasks": null
}
```












## Get multiple task status

Retrieve several tasks status given their IDs.

> Definition

```shell--curl
GET {{ VULCAIN_URL }}/{{ VERSION }}/tasks
```

```python--Python
tasks = client.Task.list(task_ids=[...])
```

### Arguments

Parameter | Type          | Default | Description
--------- | -----         | ------- | -----------
task_ids  | array(string) |         | The task IDs as a JSON array of strings

> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/tasks?task_ids=269999729&task_ids=269999730 \
{{ CURL_CREDENTIALS }}
```

```python--Python
tasks = client.Task.list(task_ids=[269999729, 269999730])
```

### Response

A paginated list of [task objects](#task_object).

Attribute | Type    | Description
--------- | ------- | -----------
count     | int     | The total number of results.
next      | string  | The URL to the next page.
previous  | string  | The URL to the previous page.
results   | array([object](#task_object)) | A list of [task objects](#task_object).

> Example Response

```json
{
    "count": 2,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": "269999729",
            "status": "success",
            "error": null,
            "date_created": "2018-03-10T20:38:12.818792Z",
            "date_updated": "2018-03-10T20:38:13.032942Z",
            "data": {
                "outputs": [
                    {
                        "labels": {
                            "predicted": [
                                {
                                    "threshold": 0.025,
                                    "label_id": 207,
                                    "score": 0.952849746,
                                    "label_name": "golden retriever"
                                }
                            ],
                            "discarded": []
                        }
                    }
                ]
            },
            "subtasks": null
        },
        {
            "id": "269999730",
            "status": "success",
            "error": null,
            "date_created": "2018-03-10T20:39:47.346716Z",
            "date_updated": "2018-03-10T20:39:47.553246Z",
            "data": {
                "outputs": [
                    {
                        "labels": {
                            "predicted": [
                                {
                                    "threshold": 0.025,
                                    "label_id": 207,
                                    "score": 0.952849746,
                                    "label_name": "golden retriever"
                                }
                            ],
                            "discarded": []
                        }
                    }
                ]
            },
            "subtasks": null
        }
    ]
}
```



