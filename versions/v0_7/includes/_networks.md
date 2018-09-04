# Neural Networks

<a name="nn_object"></a>
## The Network Object

A neural network object describes how input data should be preprocessed to be able to perform a simple inference and get raw output features from any layer.

Attribute           | Type   | Attributes | Description
------------------- | ------ | ---------- | -----------
id                  | int    | read-only  | The ID of the neural network.
name                | string |            | A short name for your network.
description         | string |            | A longer description of your network.
update_date         | string | read-only  | Date time (ISO 8601 format) of the last update of the network.
metadata            | object |            | A JSON field containing any kind of information that you may find interesting to store.
framework           | string | immutable  | A string describing which framework to use for your network. Possible values are: <ul><li>`nv-caffe-0.x-mod`: A version of [Caffe modified by NVIDIA](https://github.com/NVIDIA/caffe) and deepomatic to add support for Faster-RCNN. Currently version **0.16.4**</li><li>`tensorflow-1.x`: [Tensorflow](https://github.com/tensorflow): currently version **1.4**</li></ul>
preprocessing       | [object](#nn_preprocessing_object) | immutable  | A [preprocessing object](#nn_preprocessing_object) to describe how input data should be pre-processed. *Once the network is created, you cannot modify this field anymore*.
task_id             | int    | read-only  | ID of the task containing the deployment status of the network.

<a name="nn_preprocessing_object"></a>
### Preprocessing Object

This object describes how data should be preprocessed for each input of the network.

Attribute           | Type   | Description
------------------- | ------ | -----------
inputs              | array([object](#nn_input_preprocessing_object)) | A list of [Input Preprocessing Object](#nn_input_preprocessing_object). The order matters as input data will be fed in the same order at inference time.
batched_output      | bool   | Set this to `True` if your network cannot handle batches because the first dimension of the outputs of your network is not related to the batch size. This is typically the case for vanilla Faster-RCNN models.

<a name="nn_input_preprocessing_object"></a>
**Input Preprocessing Object**

Attribute           | Type   | Description
------------------- | ------ | -----------
tensor_name         | string | The name of the input tensor that this input will feed.
image               | [object](#nn_image_preprocessing_object) | An [Image Preprocessing Object](#nn_image_preprocessing_object). Currently the only supported input type.


<a name="nn_image_preprocessing_object"></a>
**Image Preprocessing Object**

Attribute           | Type   | Description
------------------- | ------ | -----------
dimension_order     | string | A value describing the order of the dimensions in a batch<br> N = batch_size, C = Channel, H = Height, W = Width<br> Possible values are: <ul><li>`NCHW`</li><li>`NCWH`</li><li>`NHWC`</li><li>`NWHC`</li></ul>
resize_type         | string | Possible values are: <ul><li>`SQUASH`: image is resized to fit network input, loosing aspect ratio.</li><li>`CROP`: image is resized so that the smallest side fits the network input, the rest is cropped.</li><li>`FILL`: image is resized so that the largest side fits the network input, the rest is filled with white.</li><li>`NETWORK`: image is resized so that its largest side fits `target_size` (see below) and the network is reshaped accordingly.</li></ul>
target_size         | string | Target size of the input image. It might have multiple formats. In the following `W`, `H` and `N` denote integer numbers, `W` (and `H`) being used specifically for width (and height), respectively: <ul><li>`WxH`: image is resized so that width and height fit the specified sizes.</li><li>`N`: image is resized so that the largest side of the input image matches the specified number of pixels.</li></ul>
color_channels      | string | Might be `RGB`, `BGR` or `L` (for gray levels).
pixel_scaling       | float  | Pixel values will normalized between 0 and `pixel_scaling` **before** mean substraction.
mean_file           | string | <a name="mean_file_descr"></a> Name of the file containing the mean to substract from input, see [create a new network](#create_a_network). It might either be a Caffe mean file with a `.binaryproto` extension, or a numpy serialized array with `.npy` extension.










<a name="create_a_network"></a>
## Create a Network

Creates a new custom network after you have trained a model of your own on your local computer.

> Definition

```shell--curl
POST {{ VULCAIN_URL }}/{{ VERSION }}/networks
```

```python--Python
client.Network.create(...)
```

### Arguments

Parameter           | Type    | Default  | Description
------------------- | ------- | -------- | -----------
name                | string  |      | A short name for your network.
description         | string  | ""   | A longer description of your network.
metadata            | object  | {}   | A JSON field containing any kind of information that you may find interesting to store.
framework           | string |       | A string describing which framework to use for your network. Possible values are: <ul><li>`nv-caffe-0.x-mod`: A version of [Caffe modified by NVIDIA](https://github.com/NVIDIA/caffe) and deepomatic to add support for Faster-RCNN. Currently version **0.16.4**</li><li>`tensorflow-1.x`: [Tensorflow](https://github.com/tensorflow): currently version **1.4**</li></ul>
preprocessing       | [object](#nn_preprocessing_object) |     | A [preprocessing object](#nn_preprocessing_object) to describe how input data should be pre-processed. *Once the network is created, you cannot modify this field anymore*.
*&lt;additionnal-files&gt;* | file | | Extra files for network graph and weights, as well as mean files needed by the preprocessing. See below.

#### Files for Caffe (framework = `nv-caffe-0.x-mod`)

You need to specify at least those two files:

- `deploy.prototxt`: the file that specifies the network architecture.
- `snapshot.caffemodel`: the file that stores the parameters of the network.

#### Files for Tensorflow (framework = `tensorflow-1.x`)

You need to specify at least one of those files:

- `saved_model.pb`: the file that specifies the the network architecture.
- `saved_model.pbtxt`: same as above but serialized in it text format.

If the saved model does not embed the variables' weights, you may need to specify those additionnal files:

- `variables.data-00000-of-00001`: the file that specifies variables' weights. It is usually located in a *variables* directory. Numbers can change but must respect those of your original file.
- `variables.index`: the index of variables. It is usually located in a *variables* directory.

> Example Request

```shell--curl
# We download the Caffe a GoogleNet pre-trained network
curl -o /tmp/deploy.prototxt https://raw.githubusercontent.com/BVLC/caffe/master/models/bvlc_googlenet/deploy.prototxt
curl -o /tmp/snapshot.caffemodel http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel
curl -o /tmp/caffe_ilsvrc12.tar.gz http://dl.caffe.berkeleyvision.org/caffe_ilsvrc12.tar.gz
tar -zxvf /tmp/caffe_ilsvrc12.tar.gz -C /tmp

# Now proceed to upload
curl {{ VULCAIN_URL }}/{{ VERSION }}/networks \
{{ CURL_CREDENTIALS }} \
-F name='my new network' \
-F description='trained with more images' \
-F metadata='{"author": "me", "project": "Go to mars"}' \
-F framework='nv-caffe-0.x-mod' \
-F preprocessing='{"inputs": [{"tensor_name": "data","image": {"dimension_order":"NCHW", "target_size":"224x224", "resize_type":"SQUASH", "mean_file": "mean_file_1.binaryproto", "color_channels": "BGR", "pixel_scaling": 255.0, "data_type": "FLOAT32"}}], "batched_output": true}' \
-F deploy.prototxt=@/tmp/deploy.prototxt \
-F snapshot.caffemodel=@/tmp/snapshot.caffemodel \
-F mean_file_1.binaryproto=@/tmp/imagenet_mean.binaryproto
```

```python--Python
import sys, tarfile
if sys.version_info >= (3, 0):
    from urllib.request import urlretrieve
else:
    from urllib import urlretrieve

# Initialize the client
{{ PYTHON_CREDENTIALS }}

# Helper function to download demo resources for the Caffe pre-trained networks
def download(url, local_path):
    if not os.path.isfile(local_path):
        print("Downloading {} to {}".format(url, local_path))
        urlretrieve(url, local_path)
        if url.endswith('.tar.gz'):
            tar = tarfile.open(local_path, "r:gz")
            tar.extractall(path='/tmp/')
            tar.close()
    else:
        print("Skipping download of {} to {}: file already exist".format(url, local_path))
    return local_path

# We download the Caffe a GoogleNet pre-trained network
deploy_prototxt = download('https://raw.githubusercontent.com/BVLC/caffe/master/models/bvlc_googlenet/deploy.prototxt', '/tmp/deploy.prototxt')
snapshot_caffemodel = download('http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel', '/tmp/snapshot.caffemodel')
mean_file = download('http://dl.caffe.berkeleyvision.org/caffe_ilsvrc12.tar.gz', '/tmp/imagenet_mean.binaryproto')

# Here, we define the network preprocessing.
# Please refer to the documentation to see what each field is used for.
preprocessing = {
    "inputs": [
        {
            "tensor_name": "data",
            "image": {
                "color_channels": "BGR",
                "target_size": "224x224",
                "resize_type": "SQUASH",
                "mean_file": "mean.binaryproto",
                "dimension_order": "NCHW",
                "pixel_scaling": 255.0,
                "data_type": "FLOAT32"
            }
        }
    ],
    "batched_output": True
}

# We now register the three files needed by our network
files = {
    'deploy.prototxt': deploy_prototxt,
    'snapshot.caffemodel': snapshot_caffemodel,
    'mean.binaryproto': mean_file
}

# We upload the network
network = client.Network.create(
    name="My first network",
    framework='nv-caffe-0.x-mod',
    preprocessing=preprocessing,
    files=files
)
```

#### Additionnal files for preprocessing

You might also include any additional file as required by you various input types, for exemple any mean file named as you like and whose name is refered by the `mean_file` parameter field of a [preprocessing object](#nn_preprocessing_object)) (as long it has one of the supported extensions, see the [`mean_file`](#mean_file_descr). Please refer to [Saving mean files](#saving_mean_file) on the right panel to find out how to save you mean files before sending them to the API.

> <a name="saving_mean_file"></a> Saving mean files

> In order to save numpy tensor means to files before sending them to the API, please proceed like this:

```python
import numpy as np

# example mean file when `dimension_order == "HWC"` and H = 1, W = 1 and C = 3
# typically, your mean image as been compute on the training images and you already
# have this tensor available.
example_mean_file = np.ones((1, 1, 3))

# Save this mean to 'mean.npy'
with open('mean.npy', 'wb') as f:
    np.save(f, mean, allow_pickle=False)

# You can now use `"mean_file": "mean.npy"` in the preprocessing JSON
# {
#   ...
#   "mean_file": "mean.npy"
#   ...
# }
```

### Response

A [neural network object](#nn_object)

> Example Response

```json
 {
    "id": 42,
    "name": "My first network",
    "description": "A neural network trained on some data",
    "task_id": 123,
    "update_date": "2018-02-16T16:37:25.148189Z",
    "metadata": {
        "any": "value"
    },
    "preprocessing": {
        "inputs": [
            {
                "tensor_name": "data",
                "image": {
                    "dimension_order": "NCHW",
                    "target_size": "224x224",
                    "resize_type": "SQUASH",
                    "mean_file": "mean.proto.bin",
                    "color_channels": "BGR",
                    "pixel_scaling": 255.0,
                    "data_type": "FLOAT32"
                }
            }
        ],
        "batched_output": true
    }
}
```







<a name="list_networks"></a>
## List Networks

Get the list of existing neural networks.

> Definition

```shell--curl
# To list public networks, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/networks/public

# To list your own networks, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/networks
```

```python--Python
# To list public networks, use:
client.Network.list(public=True)

# To list your own networks, use:
client.Network.list()
```

> Example Request

```shell--curl
# For public networks:
curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/public \
{{ CURL_CREDENTIALS }}

# For private networks:
curl {{ VULCAIN_URL }}/{{ VERSION }}/networks \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

# For public networks:
for network in client.Network.list(public=True):
    print(network)

# For private networks:
for network in client.Network.list():
    print(network)
```

### Response

A paginated list of responses.

Attribute | Type    | Description
--------- | ------- | -----------
count     | int     | The total number of results.
next      | string  | The URL to the next page.
previous  | string  | The URL to the previous page.
results   | array([object](#nn_object)) | A list of your [neural networks objects](#nn_object)

> Example Response

```json
{
    "count": 1,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 1,
            "name": "Alexnet",
            "description": "Alexnet",
            "task_id": "123",
            "update_date": "2018-02-16T13:45:36.078955Z",
            "metadata": {},
            "preprocessing": {
                "inputs": [
                    {
                        "tensor_name": "data",
                        "image": {
                            "dimension_order": "NCHW",
                            "target_size": "224x224",
                            "resize_type": "SQUASH",
                            "mean_file": "data_mean.proto.bin",
                            "color_channels": "BGR",
                            "pixel_scaling": 255.0,
                            "data_type": "FLOAT32"
                        }
                    }
                ],
                "batched_output": true
            }
        }
    ]
}
```





<a name="get_network"></a>
## Retrieve a Network

Retrieve a neural network by ID.

> Definition

```shell--curl
# To retrieve a public network, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/networks/public/{NETWORK_ID}

# To retrieve your own network, use:
GET {{ VULCAIN_URL }}/{{ VERSION }}/networks/{NETWORK_ID}
```

```python--Python
# {NETWORK_ID} may be a string for a public
# network or an integer for your own network.
client.Network.retrieve({NETWORK_ID})
```

### Arguments

Parameter  | Type    | Default | Description
---------  | ------- | ------- | -----------
network_id | int     |         | The ID of the neural network to get.

> Example Request

```shell--curl
# For a public network:
curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/public/imagenet-inception-v1 \
{{ CURL_CREDENTIALS }}

# For a private network:
curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/42 \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

# For a public network:
client.Network.retrieve("imagenet-inception-v1")

# For a private network:
client.Network.retrieve(42)
```

### Response

A [neural networks object](#nn_object).

> Example Response

```json
{
    "id": 1,
    "name": "Alexnet",
    "description": "Alexnet",
    "task_id": "123",
    "update_date": "2018-02-16T13:45:36.078955Z",
    "metadata": {},
    "preprocessing": {
        "inputs": [
            {
                "tensor_name": "data",
                "image": {
                    "dimension_order": "NCHW",
                    "target_size": "224x224",
                    "resize_type": "SQUASH",
                    "mean_file": "data_mean.proto.bin",
                    "color_channels": "BGR",
                    "pixel_scaling": 255.0,
                    "data_type": "FLOAT32"
                }
            }
        ],
        "batched_output": true
    }
}
```








<a name="edit_network"></a>
## Edit a Network

Updates the specified network by setting the values of the parameters passed.
Any parameters not provided will be left unchanged.

This request accepts only the `name`, `name` and `metadata` arguments. Other values are immutable.

> Definition

```shell--curl
PATCH {{ VULCAIN_URL }}/{{ VERSION }}/networks/{NETWORK_ID}
```

```python--Python
network = client.Network.retrieve({NETWORK_ID})
network.update(...)
```

### Arguments

Parameter           | Type    | Attributes          | Description
------------------- | ------- | ------------------- | -----------
name                | string  | optionnal           | A short name for your network.
description         | string  | optionnal           | A longer description of your network.
metadata            | object  | optionnal           | A JSON field containing any kind of information that you may find interesting to store.

> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/42 \
{{ CURL_CREDENTIALS }} \
-d '{"name": "new name", "description":"new description"}' \
-X PATCH
```

```python--Python
{{ PYTHON_CREDENTIALS }}

network = client.Network.retrieve(42)
network.update(
    name="new name",
    description="new description"
)
```

### Response

A [neural networks object](#nn_object).









<a name="delete_network"></a>
## Delete a Network

Permanently deletes a network. It cannot be undone.
Attached resources like recognition versions will also be suppressed.

> Definition

```shell--curl
DELETE {{ VULCAIN_URL }}/{{ VERSION }}/networks/{NETWORK_ID}
```

```python--Python
network = client.Network.retrieve({NETWORK_ID})
network.delete()
```

### Arguments

Parameter           | Type    | Default             | Description
------------------- | ------- | ------------------- | -----------
id                  | int     |                     | The Neural Network ID to delete.

> Example Request

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/42 \
{{ CURL_CREDENTIALS }} \
-X DELETE
```

```python--Python
{{ PYTHON_CREDENTIALS }}

network = client.Network.retrieve(42)
network.delete()
```

### Response

Return 204 (no content).









<!-- <a name="inference_network"></a> -->
<!-- ## Network Inference -->

<!-- Run a forward pass on the specified network. This endpoint returns a task ID. -->

<!-- > Definition -->

<!-- ```shell--curl -->
<!-- # To run inference on a public network, use: -->
<!-- POST {{ VULCAIN_URL }}/{{ VERSION }}/networks/public/{NETWORK_ID}/inference -->

<!-- # To run inference on your own network, use: -->
<!-- POST {{ VULCAIN_URL }}/{{ VERSION }}/networks/{NETWORK_ID}/inference -->
<!-- ``` -->

<!-- ```python--Python -->
<!-- # {NETWORK_ID} may be a string for a public -->
<!-- # network or an integer for your own network. -->
<!-- network = client.Network.retrieve({NETWORK_ID}) -->
<!-- network.inference(...) -->
<!-- ``` -->

<!-- ### Arguments -->

<!-- Parameter      | Type          | Default | Description -->
<!-- -------------- | ------------- | ------- | ----------- -->
<!-- network_id     | int           |         | The neural network ID -->
<!-- inputs         | array([object](#input_object)) |         | The inputs of the neural network as an array of [input objects](#input_object). *Must be non empty.* -->
<!-- output_tensors | array(string) |         | An array of tensors to output. *Must be non empty.* -->

<!-- > Example Request -->

<!-- ```shell--curl -->
<!-- URL=https://static.deepomatic.com/resources/demos/api-clients/dog2.jpg -->
<!-- # Inference from an URL: -->
<!-- curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/public/imagenet-inception-v1/inference \ -->
<!-- {{ CURL_CREDENTIALS }} \ -->
<!-- -d inputs[0]image.source=${URL} \ -->
<!-- -d output_tensors="prob" \ -->
<!-- -d output_tensors="pool2/3x3_s2" \ -->
<!-- -d output_tensors="pool5/7x7_s1" -->

<!-- # You can also directly send an image file: -->
<!-- curl ${URL} > /tmp/img.jpg -->
<!-- curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/public/imagenet-inception-v1/inference \ -->
<!-- {{ CURL_CREDENTIALS }} \ -->
<!-- -F inputs[0]image.source=@/tmp/img.jpg \ -->
<!-- -F output_tensors="prob" -->

<!-- # You can finally send base64 data by prefixing it with 'data:image/*;base64,' -->
<!-- BASE64_DATA=$(cat /tmp/img.jpg | base64) -->
<!-- curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/public/imagenet-inception-v1/inference \ -->
<!-- {{ CURL_CREDENTIALS }} \ -->
<!-- -d inputs[0]image.source="data:image/*%3Bbase64,${BASE64_DATA}" \ -->
<!-- -d output_tensors="prob" -->

<!-- # You can finally send base64 data by prefixing it with 'data:image/*;binary,' -->
<!-- FORM_ENCODED_BINARY_DATA="%5C0%5C232%5C45%5C13" -->
<!-- curl {{ VULCAIN_URL }}/{{ VERSION }}/networks/public/imagenet-inception-v1/inference \ -->
<!-- {{ CURL_CREDENTIALS }} \ -->
<!-- -d inputs[0]image.source="data:image/*%3Bbinary,${FORM_ENCODED_BINARY_DATA}" \ -->
<!-- -d output_tensors="prob" \ -->
<!-- -H "Content-Type: application/x-www-form-urlencoded" -->
<!-- ``` -->

<!-- ```python--Python -->
<!-- import base64 -->
<!-- import sys, tarfile -->
<!-- if sys.version_info >= (3, 0): -->
<!--     from urllib.request import urlretrieve -->
<!-- else: -->
<!--     from urllib import urlretrieve -->

<!-- from deepomatic import ImageInput -->
<!-- {{ PYTHON_CREDENTIALS }} -->

<!-- network = client.Network.retrieve("imagenet-inception-v1") -->

<!-- # Inference from an URL: -->
<!-- url = "https://static.deepomatic.com/resources/demos/api-clients/dog2.jpg" -->
<!-- network.inference(inputs=[ImageInput(url)], output_tensors=["prob", "pool2/3x3_s2", "pool5/7x7_s1"]) -->

<!-- # You can also directly send an image file: -->
<!-- urlretrieve(url, '/tmp/img.jpg') -->
<!-- with open('/tmp/img.jpg', 'rb') as fp: -->
<!--     network.inference(inputs=[ImageInput(fp)], output_tensors=["prob"]) -->

<!-- # You can also send binary data: -->
<!-- with open('/tmp/img.jpg', 'rb') as fp: -->
<!--     binary_data = fp.read() -->

<!-- network.inference(inputs=[ImageInput(binary_data, encoding="binary")], output_tensors=["prob"]) -->

<!-- # If you finally want to send base64 data, you can use: -->
<!-- base64_data = base64.b64encode(binary_data) -->
<!-- network.inference(inputs=[ImageInput(base64_data, encoding="base64")], output_tensors=["prob"]) -->
<!-- ``` -->

<!-- ### Response -->

<!-- The task data will contain the list of request tensors, in base64 format: -->

<!-- Attribute | Type    | Description -->
<!-- --------- | ------- | ----------- -->
<!-- tensors   | array([object](#tensor_object))  | An array of [tensors objects](#tensor_object). -->

<!-- <a name="tensor_object"></a> -->
<!-- #### Tensor Object -->

<!-- A tensor is a multi-dimensional array of numbers: -->

<!-- Attribute | Type       | Description -->
<!-- --------- | -------    | ----------- -->
<!-- name      | string     | The name of the tensor. -->
<!-- dim       | array(int) | An array of integers representing the tensor dimensions. -->
<!-- data      | array(float) | Tensor data linearized in row-major order. -->

<!-- > Example Response -->

<!-- ```json -->
<!-- { -->
<!--     "task_id": "123" -->
<!-- } -->
<!-- ``` -->

<!-- > Example of Task Data -->

<!-- ```json -->
<!-- { -->
<!--     "tensors": [ -->
<!--         { -->
<!--             "name": "some_tensor", -->
<!--             "dim": [1, 3, 2, 1], -->
<!--             "data": [7.17177295e-09, 9.09684132e-08, 7.82869236e-09, 2.53358806e-10, 3.2443765e-08, 3.22385874e-09] -->
<!--         } -->
<!--     ] -->
<!-- } -->
<!-- ``` -->
