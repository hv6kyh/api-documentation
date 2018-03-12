# Detection

## Getting Started

If you want to find objects on an image, you can use our detectors by using this endpoint:
```GET /{{ VERSION }}/detect/{:detector_type}/?url=https://host.com/my_url.png```
Where {:detector_type} is either fashion,furnitures or weapons.
Also, makes sure the URL is encoded in case it contains special characters.

You can also upload an image using this endpoint:
```POST /{{ VERSION }}/detect/{:detector_type}/```
In the body, add the base64 encoded image:
```
{
    "base64": "imageEncodedInBase64"
}
```

#### Response

> ### Example of Response

```json
{
    "task_id" : 1234,
    "status" : "pending",
    "data" : {
        "boxes"  : "",
        "width"  : "",
        "height" : ""
    }
}
```

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












<a name="detector_object"></a>
## Detector object

Attribute | Type    | Description
--------- | ------- | -----------
id        | int     | The ID of the detector
name          | string | Name of the detector
network_model | string | The id of the network used to produce features
is_public       | bool   | True if the detector is a public model provided by deepomatic.







## Add a detector

A detector based on Faster-RCNN. Labels are taken from <a href="#nn_version_object">Neural Network Version</a>.


> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/models/{:network_id}/detectors```

> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/models/{:network_id}/detectors" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" -d '{ "name": "Cars detection" }'
```



### Arguments


Parameter     | Type          | Default | Description
------------- | -------       | ------- | -----------
network_model | string        |         | The id of the network it should detect on
name          | string        |         | Name of the detector


> ### Example of Response

```json
{
    "id" : 1,
    "name" : "Human vs Robot",
}
```

### Response


Attribute | Type    | Description
--------- | ------- | -----------
id        | int     | The id of the created detector
name      | string  | Name of the detector















## List detectors

List both public and private detectors

> ### Definition
```GET {{ VULCAIN_URL }}/{{ VERSION }}/detect/detectors```

> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/detect/detectors" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

> ### Example of Response

```json
{
    "detectors": [
        {
            "id": 1,
            "name": "Fashion detector (public)",
            "network_model": 39,
            "network_model_name": "fashion",
            "is_public": true
        }
    ]
}
```

### Response

Attribute | Type    | Description
--------- | ------- | -----------
detectors | array(object)  | An array of [detector objects](#detector_object)












## Detection Request

> ### Definition
```GET {{ VULCAIN_URL }}/{{ VERSION }}/detect/{:id}```
```POST {{ VULCAIN_URL }}/{{ VERSION }}/detect/{:id}```


> ### Example Request

```shell
$ curl "{{ VULCAIN_URL }}/{{ VERSION }}/detect/fashion" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" -d url=http://host.com/url_of_my_image
```

> ### Example Response

```json
{
    "task_id": "123"
}
```

> ### Example Task Data

```json
{
    "width": 2000,
    "height": 3000,
    "boxes": {
        "dress": [
            {
                "xmin": 0.1364911049604416,
                "ymin": 0.004391632508486509,
                "ymax": 0.9956156015396118,
                "xmax": 0.8249058127403259,
                "proba": 0.9939268231391907
            }
        ]
    }
}
```

Run a detector on an image and outputs predicted bounding boxes and tags. This endpoint returns a task ID.

### Arguments

<aside class="notice">
You must not specify both 'url' and 'base64' fields. Only one of them is required.
</aside>

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
id        | string  |         | The clasifier ID - OR - one of "fashion", "furniture", "streets", "weapons".
url       | string  |         | The url of the image
base64    | string  |         | The content of the image encoded in base64
all_boxes | string  | ""      | Add a non empty value to get all detected boxes even if their probability is below the detection threshold.
min_largest_side | integer | 500  | If input image is smaller, it will be resized.
max_largest_side | integer | 1000 | If input image is larger, it will be resized.

### Response

The task data field will contain the detected bounding boxes with their associated probability and tags.

<aside class="warning">
The 'boxes' field response format is deprecated and will be changed in v0.7.
</aside>

Attribute | Type    | Description
--------- | ------- | -----------
width     | int     | Input image width.
height    | int     | Input image height.
boxes     | object  | An object with keys that represent the detected tags and store an array of modified [bounding box objects](#bbox_object) with an additionnal `proba` field. See "Example Task Data" on the side. This format is deprecated and will be modified in v0.7.









