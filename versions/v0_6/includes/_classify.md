# Classification

<a name="classifier_object"></a>
## Classifier object

Attribute | Type    | Description
--------- | ------- | -----------
id        | int     | The ID of the classifier
name          | string | Name of the classifier
network_model | string | The id of the network it should classify on
has_svm       | bool   | True if a linear model has been provided
output_layers | array(string)  | An array of output layers.
normalization | string        |         | One of: L1_NORM, L2_NORM, HELLINGER
is_public       | bool   | True if the classifier is a public model provided by deepomatic.


## Add a classifier

A classifier can either be one output of a Neural Network or a trained SVM (LogisticRegression) based on the output_layers of a Neural Network.

> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/models/{:network_id}/classifiers```

> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/models/{:network_id}/classifiers" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" -F 'name="Human vs Robot"' -F 'output_layers="[\"prob\", \"fc7\"]' -F 'normalization="L2_NORM' -F model=~/my_svm.pkl
```



### Arguments


Parameter     | Type          | Default | Description
------------- | -------       | ------- | -----------
name          | string        |         | Name of the classifier
network_model | string        |         | The id of the network it should classify on
output_layers | array(string) |         | An array of layer. If no model is provided can only have one output_layer.
normalization | string        |         | One of: L1_NORM, L2_NORM, HELLINGER
model         | file          |         | If provided, must be a trained sklearn.linear_model.LogisticRegression pickle file. Make sure it has been trained with the same neural network and using the same output_layers.


> ### Example of Response

```json
{
    "id": 316,
    "name": "GoogleNet (public)",
    "output_layers": [
        "prob"
    ],
    "network_model": 38,
    "has_svm": false,
    "normalization": "RAW",
    "is_public": true
}
```

### Response

Attribute | Type    | Description
--------- | ------- | -----------
id        | int     | The ID of the classifier
name          | string | Name of the classifier
network_model | string | The id of the network it should classify on
has_svm       | bool   | True if a linear model has been provided
output_layers | array(string)  | An array of output layers.
normalization | string        |         | One of: L1_NORM, L2_NORM, HELLINGER
is_public       | bool   | True if the classifier is a public model provided by deepomatic.











## List classifiers

List both public and private classifiers

> ### Definition
```GET {{ VULCAIN_URL }}/{{ VERSION }}/classify/classifiers```

> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/classify/classifiers" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

> ### Example of Response

```json
{
    "classifiers": [
        {
            "id": 316,
            "name": "GoogleNet (public)",
            "output_layers": [
                "prob"
            ],
            "network_model": 38,
            "has_svm": false,
            "normalization": "RAW",
            "is_public": true
        }
    ]
}
```

### Response

Attribute | Type    | Description
--------- | ------- | -----------
classifiers | array(object)  | An array of [classifier objects](#classifier_object)








## Classification Request

> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/classify/models/{:id}/test```

> ### Example Request

```shell
$ curl "{{ VULCAIN_URL }}/{{ VERSION }}/classify/models/123/test" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" -d url=http://host.com/url_of_my_image
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
    "category": "cat",
    "proba": 0.74,
    "all_proba": [
        {
            "category": "cat",
            "proba": 0.74
        },
        {
            "category": "dog",
            "proba": 0.26
        }
    ]
}
```

Run a classifier on an image and outputs predicted tags. This endpoint returns a task ID.

### Arguments

<aside class="notice">
You must not specify both 'url' and 'base64' fields. Only one of them is required.
</aside>

<aside class="warning">
If you use a neural network directly as a classifier, you actually need to encaspulate the body in a "img" parameter containing an <a href="#image_object">image object</a>. See example of request on the right. This will be fixed in v0.7.
</aside>

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
id        | int     |         | The clasifier ID
url       | string  |         | The url of the image
base64    | string  |         | The content of the image encoded in base64
polygon   | array(object)  | null | An array of [point objects](#point_object) of size at least 3 to crop the image
bbox      | object  | null    | A [bounding box object](#bbox_object) to crop the image

> ### Example of deprecated request for neural network based classifier

```json
{
    "img" : {
        "url" : "http://host.com/url_of_my_image",
    }
}
```

### Response

The task data field will contain the category, it associated probability and a detail of all possible classes sorted by decresing confidence.

Attribute | Type    | Description
--------- | ------- | -----------
category  | string  | The name of the predicted tag
proba     | float   | The associated confidence score
all_proba | array(object) | An array containing the probability of each tag, sorted by decreasing confidence. Each object of the array contains a ```category``` and a ```proba``` field.



