# Recognition Version

<a name="reco_version_object"></a>
## The Version Object

A recognition version implements a specification: this is the link between a specification and a neural network.

Attribute           | Type   | Attributes | Description
------------------- | ------ | ---------- | -----------
id                  | int    | read-only | The ID of the recognition version.
spec_id             | int    | immutable | The ID of the parent [recognition specification](#reco_spec_object).
network_id          | int    | immutable | The ID of the [neural network](#nn_object) which will cary on the computation.
post_processings    | [object](#reco_postpro_object) | immutable | The [post-processing object](#reco_postpro_object) that defines some network specific adjustments like the output tensor, some thresholds, etc. The length of this array must exactly match the length of the `outputs` field of the parent specification and the i^(th) post-processing will be matched to the i^(th) output.
spec_name           | string | read-only | The name of the [recognition specification](#reco_spec_object) corresponding to `spec_id`. This is convenient for display purposes.
network_name        | string | read-only | The name of the [neural network](#nn_object) corresponding to `network_id`. This is convenient for display purposes.
update_date         | string | read-only | Date time (ISO 8601 format) of the creation specification version.

<a name="reco_postpro_object"></a>
### Post-processing Object

<aside class="notice">
The fields of this object are mutually exclusive: you must specify exactly one of them.
</aside>

Attribute           | Type   | Description
------------------- | ------ | -----------
classification      | [object](#reco_pp_classification_object) | A post-processing of type [classification](#reco_pp_classification_object) for an output of type [labels](#reco_output_object).
detection           | [object](#reco_pp_detection_object)      | A post-processing of type [detection](#reco_pp_detection_object) for an output of type [labels](#reco_output_object).

<a name="reco_pp_classification_object"></a>
### Classification Post-processing Object

Attribute           | Type   | Description
------------------- | ------ | -----------
output_tensor       | string | The name of the network tensor that holds the classification scores.
thresholds          | array(float) | A list of threshold for each label of the recognition specification. The label will be considered present if its score is greater than the threshold. The length of this array must exactly match the length of the `labels` field of the parent **labels** specification and the i^(th) threshold will be matched to the i^(th) label.

<a name="reco_pp_detection_object"></a>
### Detection Post-processing Object

<aside class="notice">
You must specify exactly one of the <code>anchored_output</code> or <code>direct_output</code> fields.
</aside>

Attribute           | Type   | Description
------------------- | ------ | -----------
anchored_output     | object | (optional) Some neural networks output some anchor bouding boxes together with the offsets to apply to those anchors to get the final bounding boxes. Use this if this is the case of your network.<br/>This object must have the three following fields:<ul><li>`scores_tensor`: the name of the output tensor containing the scores for each labels and boxes. It must be of size `N x (L + 1)` where `N` is the number of region proposals and `L` is the number of labels in the recognition specification. The background score must be the additionnal first column of the tensor.</li><li>`anchors_tensor`: the name of the output tensor containing the anchors. It must be of size `N x 5` where the 1^(st) column is the region proposal score, the 2^(nd) and 3^(rd) columns are the `x` and `y` coordinates of the upper-left corner and the 4^(th) and 5^(th) columns are its width and height.</li><li>`offsets_tensor`: the name of the output tensor containing the offsets for each classe (including background) and anchor. It must be of size `N * (L + 1) * 4` where the first 4 columns correspond to the background label and column order is the same as above: x, y, width, height.</li></ul>
direct_output       | object | (optional) Some neural networks directly output the final bounding boxes. Use this if this is the case of your network.<br/>This object must have the two following fields:<ul><li>`scores_tensor`: the name of the output tensor containing the scores for each labels and boxes. It must be of size `N x L` where `N` is the number of region proposals and `L` is the number of labels in the recognition specification.</li><li>`classes_tensor`: the name of the output tensor containing the classes for each labels and boxes. It must be of size `N x L` where `N` is the number of region proposals and `L` is the number of labels in the recognition specification. Be careful, it will contain the ids of the classes mapped in the specification, not the row number of the corresponding label.</li><li>`boxes_tensor`: the name of the output tensor containing the boxes. It must be of size `N x L x 4` where the groups of 4 columns correspond to `xmin`, `ymin`, `xmax` and `ymax` coordinates of the bounding boxes, `xmin` and `ymin` being the coordinates of the upper-left corner.</li></ul>
thresholds          | array(float) | A list of threshold for each label of the recognition specification. The label will be considered present if its score is greater than the threshold. The length of this array must exactly match the length of the `labels` field of the parent **labels** specification and the i^(th) threshold will be matched to the i^(th) label.
nms_threshold       | float | The Jaccard index threshold that will be applied to NMS to decide if two boxes **of the same label** represent the same object.
normalize_wrt_tensor| string | (optional) If your neural network outputs coordinates which are not normalized, use this field to specify a tensor that would hold the input image size (image height must be the first element of the tensor, image width the second element). Can be left blank if not used.







<a name="create_a_reco_version"></a>
## Create a Version

Creates a new recognition version.

> Definition

```shell--curl
POST {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions
```

```python--Python
client.RecognitionVersion.create(...)
```

### Arguments

Parameter           | Type    | Default  | Description
------------------- | ------- | -------- | -----------
spec_id             | int     |          | The ID of the parent [recognition specification](#reco_spec_object).
network_id          | int     |          | The ID of the [neural network](#nn_object) which will cary on the computation.
post_processings    | [object](#reco_postpro_object) | | The [post-processing object](#reco_postpro_object) that defines some network specific adjustments like the output tensor, some thresholds, etc. The length of this array must exactly match the length of the `outputs` field of the parent specification and the i^(th) post-processing will be matched to the i^(th) output.


> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions \
{{ CURL_CREDENTIALS }} \
-d '{
"spec_id": 42,
"network_id": 123,
"post_processings": [{"classification": {"output_tensor": "inception_v3/logits/predictions", "thresholds": [0.025, 0.025]}}]
}' \
-H "Content-Type: application/json"
```

```python--Python
{{ PYTHON_CREDENTIALS }}

client.RecognitionVersion.create(
    spec_id=42,
    network_id=123,
    post_processings=[{
        "classification": {
            "output_tensor": "inception_v3/logits/predictions",
            "thresholds": [
                0.5,
                0.5
            ]
        }
    }]
)
```

### Response

A [recognition version object](#reco_version_object).

> Example Response

```json
{
    "id": 1,
    "spec_id": 42,
    "spec_name": "hot-dog VS not hot-dog classifier",
    "network_id": 123,
    "network_name": "hot-dog VS not hot-dog classifier",
    "update_date": "2018-03-09T18:30:43.404610Z",
    "post_processings": [{
        "classification": {
            "output_tensor": "inception_v3/logits/predictions",
            "thresholds": [
                0.5,
                0.5
            ]
        }
    }]
}
```












<a name="list_reco_versions"></a>
## List Versions

Get the list of existing recognition versions.

> Definition

```shell--curl
# To access all your versions, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions

# To access versions attached to a given recognition spec, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/{SPEC_ID}/versions
```

```python--Python
# To access all your versions, use:
client.RecognitionVersion.list()

# To access versions attached to a given recognition spec, use:
client.RecognitionSpec.retrieve({SPEC_ID}).versions()
```

> Example Request

```shell--curl
# To access all your versions:
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions \
{{ CURL_CREDENTIALS }}

# To access versions attached to a given recognition spec, use:
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/specs/42/versions \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

# To access all your versions, use:
for version in client.RecognitionVersion.list():
    print(version)

# To access versions attached to a given recognition spec, use:
for version in client.RecognitionSpec.retrieve(42).versions():
    print(version)
```

### Response

A paginated list of reponses.

Attribute | Type    | Description
--------- | ------- | -----------
count     | int     | The total number of results.
next      | string  | The URL to the next page.
previous  | string  | The URL to the previous page.
results   | array([object](#reco_version_object)) | A list of your [recognition version objects](#reco_version_object). Please note that the `post_processings` field is not present.

> Example Response

```json
{
    "count": 2,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 1,
            "spec_id": 42,
            "spec_name": "hot-dog VS not hot-dog classifier",
            "network_id": 123,
            "network_name": "hot-dog VS not hot-dog classifier",
            "update_date": "2018-03-09T18:30:43.404610Z"
        },
        ...
    ]
}
```










<a name="get_reco_version"></a>
## Get a Version

Retrieve a recognition version by ID.

```shell--curl
GET {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions/{VERSION_ID}
```

```python--Python
client.RecognitionVersion.retrieve({VERSION_ID})
```

### Arguments

Parameter           | Type    | Default             | Description
------------------- | ------- | ------------------- | -----------
version_id          | int     |                     | The ID of the version to retrieve.


> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions/1 \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

client.RecognitionVersion.retrieve(1)
```

### Response

A [recognition version object](#reco_version_object).








<a name="delete_reco_version"></a>
## Delete a Version

Permanently deletes a recognition version. It cannot be undone.

> Definition

```shell--curl
DELETE {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions/{VERSION_ID}
```

```python--Python
version = client.RecognitionVersion.retrieve({VERSION_ID})
version.delete()
```

### Arguments

Parameter           | Type    | Default             | Description
------------------- | ------- | ------------------- | -----------
version_id          | int     |                     | The ID of the version to delete.

> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions/42 \
{{ CURL_CREDENTIALS }} \
-X DELETE
```

```python--Python
{{ PYTHON_CREDENTIALS }}

version = client.RecognitionVersion.retrieve(42)
version.delete()
```

### Response

Return 204 (no content).











<a name="inference_reco_version"></a>
## Version Inference

Run a inference on this specification version. This endpoint returns a task ID. Please refer to [the Spec Inference Request](#recognition_inference_request) to have a comprehensive list of the inference request arguments and response.

> Definition

```shell--curl
POST {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions/{VERSION_ID}/inference
```

```python--Python
version = client.RecognitionVersion.retrieve({VERSION_ID})
version.inference(...)
```

> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/versions/1/inference \
{{ CURL_CREDENTIALS }} \
-d '{"inputs": [{"image": {"source": "https://static.deepomatic.com/resources/demos/api-clients/dog2.jpg"}}]}'
```

```python--Python
{{ PYTHON_CREDENTIALS }}

version = client.RecognitionVersion.retrieve(1)
url = "https://static.deepomatic.com/resources/demos/api-clients/dog2.jpg"
version.inference(inputs=[deepomatic.ImageInput(url)])
```

> Example Response

```json
{
    "task_id": "123"
}
```

