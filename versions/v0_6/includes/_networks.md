# Neural Networks

<a name="nn_object"></a>
## Neural Networks Object

Neural Network are versionned so that multiple versions of the same network can be deployed.

Attribute | Type    | Description
--------- | ------- | -----------
id        | int     | The ID of the neural network
name      | string  | The name of the neural network
description | string | A description of the neural network
current_version | object | A [neural network version object](#nn_version_object)











<a name="nn_version_object"></a>
## Neural Network Version Object

A neural network version is tied to a framework and way of preprocess data.

Attribute           | Type   | Description
------------------- | ------ | -----------
id                  | int    | The ID of the neural network version.
version_description | string | A description of the neural network version.
framework           | string | The framework used to train the model. Either "CD" or "TF".
framework_version   | string | The version of the framework used to train and deploy the model.
color_model         | string | The color model of the network's input. Either "BGR" or "RGB".
preprocessing       | string | The way images should be preprocessed. Either "STRETCH" or "FILL".
replicas            | int    | Number of nodes deployed for inference.
mean                | file   | mean.binaryproto caffe file
deploy              | file   | deploy.prototxt caffe file
model               | file   | snapshot.caffemodel file
labels              | file   | labels.txt file (each line contains a label)









## List Neural Networks

> ### Definition
```GET {{ VULCAIN_URL }}/{{ VERSION }}/models```

> ### Example Request

```shell
$ curl "{{ VULCAIN_URL }}/{{ VERSION }}/models" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

> ### Example Response

```json
{
    "models": [
        {
            "id": 19,
            "name": "alexnet",
            "description": "",
            "current_version": 1
        }
    ]
}
```

Lists both public and user's neural networks.

### Response

Attribute | Type    | Description
--------- | ------- | -----------
models | array(object) | A list of public and private [neural networks objects](#nn_object)







## Add a Network

> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/models/```

> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/models/" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" -d '{ "name": "alexnet", "description": "trained on imagenet" }'
```


> ### Example Response

```json
{
    "model": {
        "id" : 2,
        "name": "alexnet",
        "description": "trained on imagenet",
        "current_version": null
    }
}
```


### Arguments

Parameter           | Type    | Default             | Description
------------------- | ------- | ------------------- | -----------
name                | string  |                     | Name of the neural network
description         | string  |                     | Description of what the network does



### Response

Attribute | Type    | Description
--------- | ------- | -----------
model     | object  | The created network neural network





## Add a Version to a Network


It will become the current version of the neural network.


> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/models/{:id}/versions```

> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/models/19/versions" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" -F 'version_description="trained with more images"' -F 'data_layer="data"' -F 'framework="CD"' -F 'framework_version="2.4"' -F 'color_model="BGR"' -F 'preprocessing="STRETCH"' -F mean=my_network/mean.binaryproto -F deploy=my_network/deploy.prototxt -F model=my_network/snapshot.caffemodel -F labels=my_network/labels.txt
```

> ### Example Response

```json
{
    "network_id": 19,
    "task_id": "123"
}
```

### Arguments

Parameter           | Type    | Default             | Description
------------------- | ------- | ------------------- | -----------
version_description | string  |                     | A description of what have been changed
data_layer          | string  | "data"              | Input layer of the network
framework           | string  | "CD"                | For now only support "CD" (Caffe Deepomatic)
framework_version   | string  | "2.4"               | For now only support version 2.4 of Caffe
color_model         | string  | "BGR"               | Either "BGR" or "RGB" depending you trained your network using BGR images or RGB (if you don't know it should be BGR)
preprocessing       | string  | "FILL"              | Either "FILL" or "STRETCH"
deploy              | file    |                     | deploy.prototxt caffe file
model               | file    |                     | snapshot.caffemodel file
mean                | file    |  (optional)         | mean.binaryproto caffe file
labels              | file    |  (optional)         | labels.txt file (each line contains a label)
metadata            | file    |  (optional)         | For internal use only, generated by deepomatic





### Response

Attribute  | Type    | Description
---------  | ------- | -----------
network_id | int     | The parent network id
network_id | int     | The version id
task_id    | string  | The task id let you know when your version is ready











## Get a Network

> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/models/{:id}```

> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/models/19" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

> ### Example Response

```json
{
    "model": {
        "id": 19,
        "name": "alexnet",
        "description": "",
        "current_version": 1
    }
}
```

Retrieve a neural network by id.

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
id        | int     |         | The neural network ID

### Response

Attribute | Type    | Description
--------- | ------- | -----------
model     | object  | A [neural networks object](#nn_object).











## Get a Network Version List

> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/models/{:id}/versions```

> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/models/19/versions" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

> ### Example Response

```json
{
    "versions": [
        {
            "id": 27,
            "name": null,
            "data_layer": "data",
            "version_description": "Inception v1",
            "color_model": "BGR",
            "preprocessing": "STRETCH",
            "network": 38,
            "replicas": 1,
            "task_id": null,
            "framework_version": "2.1",
            "framework_label": "Caffe Deepomatic",
            "framework": "CD"
        }
    ]
}
```

Get the list of versions of a neural network.

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
id        | int     |         | The neural network ID


### Response

Attribute | Type    | Description
--------- | ------- | -----------
versions  | array(object)  | An array of [neural networks version objects](#nn_version_object).


















## Set Current Network Version

> ### Definition
```PUT {{ VULCAIN_URL }}/{{ VERSION }}/models/{:id}/versions/{:version_id}```

> ### Example Request

```shell
$ curl -XPUT "{{ VULCAIN_URL }}/{{ VERSION }}/models/19/versions/1" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

Set the current deployed version of a neural network.

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
id        | int     |         | The neural network ID
version_id| int     |         | The version ID












## Delete a Network Version

> ### Definition
```DELETE {{ VULCAIN_URL }}/{{ VERSION }}/models/{:id}/versions/{:version_id}```

> ### Example Request

```shell
$ curl -XDELETE "{{ VULCAIN_URL }}/{{ VERSION }}/models/19/versions/1" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}"
```

Delete a version of a neural network.

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
id        | int     |         | The neural network ID
version_id| int     |         | The version ID















## Inference Request

> ### Definition
```POST {{ VULCAIN_URL }}/{{ VERSION }}/models/{:id}/inference```

>```POST {{ VULCAIN_URL }}/{{ VERSION }}/models/{:id}/versions/{:version_id}/inference/```


> ### Example Request

```shell
$ curl -X POST "{{ VULCAIN_URL }}/{{ VERSION }}/models/38/inference" -H "X-APP-ID: {{APP_ID}}" -H "X-API-KEY: {{API_KEY}}" -d '{"img":{"url":"http://host.com/url_of_my_image"}, "output_layers": ["pool5/7x7_s1"]}'
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
    "tensors": [
        {
            "name": "pool5/7x7_s1",
            "dim": [1, 1024, 1, 1],
            "data": "SomeBase64Data"
        }
    ]
}
```

Run a forward pass on the specified model. When using the first endpoint, it uses the current version of the model. If you wish to use another version, please use the second endpoint and specify a version ID. This endpoint returns a task ID.

### Arguments

Parameter | Type    | Default | Description
--------- | ------- | ------- | -----------
id        | int     |         | The neural network ID
version_id| int     |         | The version ID
img       | object  |         | An [image object](#image_object).
output_layers | array(string) | | An array of tensors to output. Must be non empty.

### Response

The task data will contain the list of request tensors, in base64 format:

Attribute | Type    | Description
--------- | ------- | -----------
tensors   | array(object)  | An array of [tensors objects](#tensor_object).

<a name="tensor_object"></a>
### Tensor Object

A tensor contains binary data from some network layer.

Attribute | Type       | Description
--------- | -------    | -----------
name      | string     | The name of the layer.
dim       | array(int) | An array of integers representing the tensor dimensions.
data      | string     | Tensor binary data encoded in base64.




### Deprecation

<aside class="warning">
The endpoints will be changed to '/networks' in v0.7.
</aside>
