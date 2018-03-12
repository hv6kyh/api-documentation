# Tasks

Some endpoints do not return a direct response. Instead they return a task_id which will contain the results once ready.










<a name="task_object"></a>
## The task object

> ### Example of task object

```json
{
    "id": 269999729,
    "status": "error",
    "error": null,
    "date_created": "2017-05-10T15:46:10.264495Z",
    "date_updated": "2017-05-10T15:46:10.285370Z",
    "data": {
        "some": "keys"
    },
    "subtasks": null
}
```

The task object allow to retrieve an endpoint response or error.

Attribute | Type    | Description
--------- | ------- | -----------
id        | int     | The task ID
status    | string  | The task status, either "pending", "success", or "error"
error     | string  | Defined in case of error, it is the error message
date_created | string | The creation data timestamp
date_updated | string | The timestamp where status switched from "pending" to another status
data      | object  | The response object of the endpoint that generated the task
subtasks  | array(task) | An array of sub-tasks

<aside class="warning">
The attribute ```subtasks``` will be deprecated in v0.7.
</aside>







## Get task status

> ### Definition
```GET {{ VULCAIN_URL }}/{{ VERSION }}/tasks/{:task_id}```

> ### Example Request

```shell
$ curl "{{ VULCAIN_URL }}/{{ VERSION }}/tasks/123" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

> ### Example Response

```json
{
    "task": {
        "id": 269999729,
        "status": "error",
        "error": null,
        "date_created": "2017-05-10T15:46:10.264495Z",
        "date_updated": "2017-05-10T15:46:10.285370Z",
        "data": {
            "some": "keys"
        },
        "subtasks": null
    }
}
```

This endpoint retrieves the state of a given task.

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
task_id   | string  |         | The task ID

### Response

It returns a [task object](#task_object).

Attribute | Type    | Description
--------- | ------- | -----------
task      | object  | A [task object](#task_object)













## Get multiple task status

> ### Definition
```GET {{ VULCAIN_URL }}/{{ VERSION }}/tasks```

> ### Example Request

```shell
$ curl "{{ VULCAIN_URL }}/{{ VERSION }}/tasks" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" -d 'task_ids=["123"]'
```

> ### Example Response

```json
{
    "tasks": [
        {
            "id": 269999729,
            "status": "error",
            "error": "Some error text",
            "date_created": "2017-05-10T15:46:10.264495Z",
            "date_updated": "2017-05-10T15:46:10.285370Z",
            "data": null,
            "subtasks": null
        }
    ]
}
```

Retrieve several tasks status given their IDs.

### Arguments

Parameter | Type          | Default | Description
--------- | -----         | ------- | -----------
task_ids  | array(string)  |         | The task IDs as a JSON array of strings

### Response

It returns an array of [task object](#task_object).

Attribute | Type    | Description
--------- | ------- | -----------
tasks      | array(object)  | An array of [task object](#task_object)