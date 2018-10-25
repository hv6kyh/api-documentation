# Recognition Specification

<a name="reco_spec_object"></a>
## The Specification Object

A recognition specification describes the output format of your recognition algorithm. You may attach multiple algorithms that perform the same task to the same specification in order to leverage automatic updates of your embedded recognition models.

Attribute           | Type   | Attributes | Description
------------------- | ------ | ---------- | -----------
id                  | int (string) | read-only, string for public | The ID of the recognition specification. *This field is a string for public recognition models.*
name                | string |            | A short name for your recognition specification.
description         | string |            | A longer description of your recognition specification.
update_date         | string | read-only  | Date time (ISO 8601 format) of the last update of the recognition specification.
metadata            | object |            | A JSON field containing any kind of information that you may find interesting to store.
current_version_id  | int    | nullable, hidden for public | The ID of the current [recognition version object](#reco_version_object) that this specification will execute if you ask it to perform an inference. This is convenient if you want to allow your app to point to a constant API endpoint while keeping the possibility to smoothly update the recognition model behind. *This field is hidden for public recognition models*
outputs             | array([object](#reco_output_object)) | hidden     | The specification of the outputs you would like to recognize. Its an array of [output objects](#reco_output_object). *As this field tends to be large, it is hidden when you access the list of recognition models*.

<a name="reco_output_object"></a>
### Output Object

Attribute           | Type   | Description
------------------- | ------ | -----------
labels              | [object](#reco_labels_output_object) | An output of type [labels](#reco_labels_output_object).

<a name="reco_labels_output_object"></a>
### Labels Output Object

Attribute           | Type   | Description
------------------- | ------ | -----------
labels              | array([object](#reco_label_object)) | A list of [labels objects](#reco_label_object) that will be recognized by your model.
exclusive           | bool   | A boolean describing if the declared labels are mutually exclusive or not.
roi                 | string | ROI stands for "Region Of Interest". Possible values are: <ul><li>`NONE`: if your model if performing classification only without object localization</li><li>`BBOX`: if your model can also output bounding boxes for the multiple objects detected in the image.</li></ul>

<a name="reco_label_object"></a>
### Label Object

Attribute           | Type   | Description
------------------- | ------ | -----------
id                  | int    | The numeric ID of your label. Can be anything you want, this ID will be present in the inference response for you to use it.
name                | string | The name of the label. It will also be present in the inference response.





<a name="create_a_reco_spec"></a>
## Create a Specification

Creates a new recognition specification.

> Definition

```shell--curl
POST {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs
```

```python--Python
client.RecognitionSpec.create(...)
```

### Arguments

Parameter           | Type    | Default  | Description
------------------- | ------- | -------- | -----------
name                | string  |          | A short name for your recognition model.
description         | string  | ""       | A longer description of your recognition model.
metadata            | object  | {}       | A JSON field containing any kind of information that you may find interesting to store.
outputs             | [object](#reco_output_object)  |      | An [output object](#reco_output_object) to describe how input data should be pre-processed.


> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs \
{{ CURL_CREDENTIALS }} \
-d '{
"name": "My recognition model",
"description": "To recognize various types of birds",
"metadata": {"author": "me", "project": "Birds 101"},
"outputs": [{"labels": {"roi": "NONE", "exclusive": true, "labels": [{"id": 0, "name": "hot-dog"}, {"id": 1, "name": "not hot-dog"}]}}]
}' \
-H "Content-Type: application/json"
```

```python--Python
{{ PYTHON_CREDENTIALS }}

client.RecognitionSpec.create(
    name="hot-dog VS not hot-dog classifier",
    description="My great hot-dog VS not hot-dog classifier !",
    metadata={
        "author": "me",
        "project": "my secret project"
    },
    outputs = [{
        "labels": {
            "roi": "NONE",
            "exclusive": True,
            "labels": [{
                "id": 0,
                "name": "hot-dog"
            }, {
                "id": 1,
                "name": "not hot-dog"
            }]
        }
    }]
)
```

### Response

A [recognition specification object](#reco_spec_object).

> Example Response

```json
{
    "id": 42,
    "name": "hot-dog VS not hot-dog classifier",
    "description": "My great hot-dog VS not hot-dog classifier !",
    "task_id": 123,
    "update_date": "2018-02-16T16:37:25.148189Z",
    "metadata": {
        "author": "me",
        "project": "my secret project"
    },
    "outputs": [{
        "labels": {
            "roi": "NONE",
            "exclusive": true,
            "labels": [{
                "id": 0,
                "name": "hot-dog"
            }, {
                "id": 1,
                "name": "not hot-dog"
            }]
        }
    }],
    "current_version_id": null
}
```







<a name="list_reco_specs"></a>
## List Specifications

Get the list of existing recognition specifications.

> Definition

```shell--curl
# To list public specifications, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public

# To list your own specifications, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs
```

```python--Python
# To list public specifications, use:
client.RecognitionSpec.list(public=True)

# To list your own specifications, use:
client.RecognitionSpec.list()
```

> Example Request

```shell--curl
# For public specifications:
curl  {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public \
{{ CURL_CREDENTIALS }}

# For private networks:
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

# For public specifications:
for spec in client.RecognitionSpec.list(public=True):
    print(spec)

# For private specifications:
for spec in client.RecognitionSpec.list():
    print(spec)
```

### Response

A paginated list of reponses.

Attribute | Type    | Description
--------- | ------- | -----------
count     | int     | The total number of results.
next      | string  | The URL to the next page.
previous  | string  | The URL to the previous page.
results   | array([object](#reco_spec_object)) | A list of your [recognition specification objects](#reco_spec_object). Please note that the `output` field is not present and that `current_version_id` is unavailable for public recognition models.

> Example Response

```json
{
    "count": 2,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 42,
            "name": "My great hot-dog VS not hot-dog classifier !",
            "description": "Very complicated classifier",
            "update_date": "2018-03-09T18:30:43.404610Z",
            "current_version_id": 1,
            "metadata": {}
        },
        ...
    ]
}
```








<a name="get_reco_spec"></a>
## Get a Specification

Retrieve a recognition specification by ID.

> Definition

```shell--curl
# To retrieve a public specification, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/{SPEC_ID}

# To retrieve your own specification, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/{SPEC_ID}
```

```python--Python
# {SPEC_ID} may be a string for a public specification
# or an integer for your own specification.
client.RecognitionSpec.retrieve({SPEC_ID})
```

### Arguments

Parameter  | Type    | Default | Description
---------  | ------- | ------- | -----------
spec_id    | int     |         | The ID of the recognition specification to get.


> Example Request

```shell--curl
# For a public specification:
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/fashion-v4 \
{{ CURL_CREDENTIALS }}

# For a private specification:
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/42 \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

# For a public specification:
client.RecognitionSpec.retrieve("fashion-v4")

# For a private specification:
client.RecognitionSpec.retrieve(42)
```

### Response

A [recognition specification object](#reco_spec_object).

> Example Response

```json
{
    "id": "fashion-v4",
    "name": "Fashion detector",
    "description": "",
    "update_date": "2018-03-08T19:24:26.528815Z",
    "metadata": {},
    "outputs": [
        {
            "labels": {
                "roi": "BBOX",
                "exclusive": true,
                "labels": [
                    {
                        "id": 0,
                        "name": "sweater"
                    },
                    {
                        "id": 1,
                        "name": "hat"
                    },
                    {
                        "id": 2,
                        "name": "dress"
                    },
                    {
                        "id": 3,
                        "name": "bag"
                    },
                    {
                        "id": 4,
                        "name": "jacket-coat"
                    },
                    {
                        "id": 5,
                        "name": "shoe"
                    },
                    {
                        "id": 6,
                        "name": "pants"
                    },
                    {
                        "id": 7,
                        "name": "suit"
                    },
                    {
                        "id": 8,
                        "name": "skirt"
                    },
                    {
                        "id": 9,
                        "name": "sunglasses"
                    },
                    {
                        "id": 10,
                        "name": "romper"
                    },
                    {
                        "id": 11,
                        "name": "top-shirt"
                    },
                    {
                        "id": 12,
                        "name": "jumpsuit"
                    },
                    {
                        "id": 13,
                        "name": "shorts"
                    },
                    {
                        "id": 14,
                        "name": "swimwear"
                    }
                ]
            }
        }
    ]
}
```







<a name="edit_reco_spec"></a>
## Edit a Specification

Updates the specified specification by setting the values of the parameters passed.
Any parameters not provided will be left unchanged.

This request accepts only the `name`, `name`, `metadata` and `current_version_id` arguments. Other values are immutable.

> Definition

```shell--curl
PATCH {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/{SPEC_ID}
```

```python--Python
spec = client.RecognitionSpec.retrieve({SPEC_ID})
spec.update(...)
```

### Arguments

Parameter           | Type    | Attributes          | Description
------------------- | ------- | ------------------- | -----------
name                | string  | optionnal           | A short name for your network.
description         | string  | optionnal           | A longer description of your network.
metadata            | object  | optionnal           | A JSON field containing any kind of information that you may find interesting to store.
current_version_id  | int    |  optionnal           | The ID of the current [recognition version object](#reco_version_object) that this specification will execute if you ask it to perform an inference. This is convenient if you want to allow your app to point to a constant API endpoint while keeping the possibility to smoothly update the recognition model behind.


> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/42 \
{{ CURL_CREDENTIALS }} \
-d name='new name' \
-d current_version_id=123 \
-X PATCH
```

```python--Python
{{ PYTHON_CREDENTIALS }}

spec = client.RecognitionSpec.retrieve(42)
spec.update(
    name="new name",
    current_version_id=123
)
```

### Response

A [recognition specification object](#reco_spec_object).





<a name="delete_reco_spec"></a>
## Delete a Specification

Permanently deletes a recognition specification. It cannot be undone.
Attached resources like recognition versions will also be suppressed.

> Definition

```shell--curl
DELETE {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/{SPEC_ID}
```

```python--Python
spec = client.RecognitionSpec.retrieve({SPEC_ID})
spec.delete()
```

### Arguments

Parameter           | Type    | Default             | Description
------------------- | ------- | ------------------- | -----------
spec_id             | int     |                     | The ID of the specification to delete.


> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/42 \
{{ CURL_CREDENTIALS }} \
-X DELETE
```

```python--Python
{{ PYTHON_CREDENTIALS }}

spec = client.RecognitionSpec.retrieve(42)
spec.delete()
```

### Response

Return 204 (no content).








<a name="inference_reco_spec"></a>
## Specification Inference

Run a inference on the current version of the specification (therefore, its `current_version_id` field must not be null). This endpoint returns a task ID.

> Definition

```shell--curl
# To run inference on a public specification, use:
POST {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/{SPEC_ID}/inference

# To run inference on your own specification, use:
POST {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/{SPEC_ID}/inference
```

```python--Python
# {SPEC_ID} may be a string for a public specification
# or an integer for your own specification.
spec = client.RecognitionSpec.retrieve({SPEC_ID})
spec.inference(...)
```

<a name="#recognition_inference_request"></a>
### Arguments

Parameter      | Type          | Default | Description
-------------- | ------------- | ------- | -----------
spec_id        | int           |         | The neural network ID
inputs         | array([object](#input_object)) |         | The inputs of the neural network as an array of [input objects](#input_object). *Must be non empty.*
show_discarded  | bool         | false   | A boolean indicating if the response must include labels which did not pass the recognition threshold.
max_predictions | int          | 100     | The maximum number of predicted and discarded objects to return.


> Example Request

```shell--curl
URL=https://static.deepomatic.com/resources/demos/api-clients/dog2.jpg
# Inference from an URL:
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/fashion-v4/inference \
{{ CURL_CREDENTIALS }} \
-d inputs[0]image.source="${URL}" \
-d show_discarded="True" \
-H "Content-Type: application/json" \
-d max_predictions=100

# You can also directly send an image file or binary content using multipart/form-data:
curl ${URL} > /tmp/img.jpg
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/fashion-v4/inference \
{{ CURL_CREDENTIALS }} \
-F inputs[0]image.source=@/tmp/img.jpg

# You can also send base64 data by prefixing it with 'data:image/*;base64,' and sending it as application/json:
BASE64_DATA=$(cat /tmp/img.jpg | base64)
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/fashion-v4/inference \
{{ CURL_CREDENTIALS }} \
-H "Content-Type: application/json" \
-d inputs[0]image.source="data:image/*%3Bbase64,${BASE64_DATA}"

```

```python--Python
import base64
import sys, tarfile
if sys.version_info >= (3, 0):
    from urllib.request import urlretrieve
else:
    from urllib import urlretrieve

from deepomatic import ImageInput
{{ PYTHON_CREDENTIALS }}

spec = client.RecognitionSpec.retrieve("fashion-v4")

# Inference from an URL:
url = "https://static.deepomatic.com/resources/demos/api-clients/dog2.jpg"
spec.inference(inputs=[ImageInput(url)], show_discarded=True, max_predictions=100)

# You can also directly send an image file:
urlretrieve(url, '/tmp/img.jpg')
with open('/tmp/img.jpg', 'rb') as fp:
    spec.inference(inputs=[ImageInput(fp)])

# You can also send binary data:
with open('/tmp/img.jpg', 'rb') as fp:
    binary_data = fp.read()

spec.inference(inputs=[ImageInput(binary_data, encoding="binary")])

# If you finally want to send base64 data, you can use:
base64_data = base64.b64encode(binary_data)
spec.inference(inputs=[ImageInput(base64_data, encoding="base64")])
```

### Response

The task data will contain the list of request tensors, in base64 format:


Attribute | Type    | Description
--------- | ------- | -----------
outputs   | array([object](#inference_output_object)) | An array of [inference output objects](#inference_output_object). The i^(th) element of the array corresponds to the result of the i^(th) elements of the specification `outputs` field and version `post_processings` field.

<a name="inference_output_object"></a>
#### Inference Output Object

This object is directly related to the [output object](#reco_output_object) of the specification: they both have the same unique field. It stores the recognition inference output.

Attribute           | Type   | Description
------------------- | ------ | -----------
labels              | [object](#inference_labels_output_object) | An output of type [labels](#inference_labels_output_object).

<a name="inference_labels_output_object"></a>
#### Inference Labels Output Object

Attribute           | Type   | Description
------------------- | ------ | -----------
predicted           | array([object](#inference_labels_prediction_object)) | An array of [prediction object](#inference_labels_prediction_object). This field stores the list of recognition hypotheses whose score is above the recognition threshold.
discarded           | array([object](#inference_labels_prediction_object)) | An array of [prediction object](#inference_labels_prediction_object). If you passed `show_discared=true` in the [inference request](#recognition_inference_request), this field will store the list of recognition hypotheses whose score did not reached the recognition threshold.

<a name="inference_labels_prediction_object"></a>
#### Prediction Object

Stores information related to an object hypothesis.

Attribute | Type       | Description
--------- | -------    | -----------
label_id  | int        | The recognized label ID from the specification's [label object](#reco_label_object).
label_name| string     | The recognized label name from the specification's [label object](#reco_label_object).
score     | float      | The recognition score.
threshold | float      | The recognition threshold that was defined by the recognition version [post-processing](#reco_pp_classification_object).
sequence_index | int   | The position of the prediction if the input data was a sequence of inputs (e.g. when passing a video for a network that accepts images), null otherwise.
sequence_time | float   | If the input data is a time serie, it represents the position of the prediction corresponding to `sequence_index` in seconds, null otherwise.
roi       | [object](#prediction_roi_object) | (optionnal) If the `roi` field of the corresponding [labels output object](#reco_labels_output_object) is not `"NONE"`, this field will store a [ROI object](#prediction_roi_object).

<a name="prediction_roi_object"></a>
#### ROI Object

"ROI" stands for "Region Of Interest" and describes the position of an object.

Attribute | Type       | Description
--------- | -------    | -----------
region_id | int        | <a name="prediction_region_id"></a> The region ID. It might not be unique among all the returned prediction objects. It can be used in conjuction with `show_discarded=true` to group the `predicted` and `discarded` fields by `region_id` to identify alternate labels for a given region in case of an hesitation.
bbox      | [object](#bbox_object) | (optionnal) Present if and only if the region type is `"BBOX"` (see [labels output object](#reco_labels_output_object)).

> Example Response

```json
{
    "task_id": "123"
}
```

> Example of Task Data

```json
{
    "outputs": [{
        "labels": {
            "predicted": [{
                "label_id": 9,
                "label_name": "sunglasses",
                "score": 0.990304172,
                "threshold": 0.347,
                "roi": {
                    "region_id": 1,
                    "bbox": {
                        "xmin": 0.312604159,
                        "ymin": 0.366485775,
                        "ymax": 0.5318923,
                        "xmax": 0.666821837
                    }
                }
            }],
            "discarded": []
        }
    }]
}
```
