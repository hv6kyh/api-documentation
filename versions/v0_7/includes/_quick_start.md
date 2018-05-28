
# Quick Start

Before diving in the details of the API, let's detail first some vocabulary points that we will use consistently through this whole documentation:

- by **"framework"**: we refer to the library that was used to train a neural network. Currently only Caffe and TensorFlow are supported.
- by **"neural network"** or **"network"**: we refer to a trained deep convolutionnal neural network and all the necessary preprocessing information to be able to perform **inference** (i.e. computation) on any input image. At this point, there is no semantic on the output of the network. For that, you need to couple it with a recognition model.
- by **"recognition model"** or **"model"**: we refer to the necessary information to interpret the output of the neural network. It might be its output labels, the threshold at which it makes sense to consider a detection valid, NMS threshold, etc... A recognition model is made of a **specification** part that properly defines the output of the model and a **version** that implements this specification. A *specification* can have multiple *versions* that implement it. Specifications can currently describe *classification*, *tagging* and *detection* models:

    - **classification**: a model that is able to recognize the main content of the image among a set of N possible exclusive **labels**.
    - **tagging** (also refered as multi-label classification): a variant of classification where multiple *labels* (or **tags**) can be assigned to the same image.
    - **detection**: a model that is able to predict the position of multiple **instances** of objects in an image, given a set of N possible object *labels*. Each object *instance* is localized thanks to a **bounding box** (often shortened "bbox" below) which is a rectangle that delimits the predicted extend of the object in the image.

## Testing pre-trained models

When following the link to the API below, you will be asked for login. Simply use the same email adress and password you used for the developer dashboard.







### Listing public models

The first thing you may want to do is to try our pretrained demo image recognition models.
There are currently six of them:

- `imagenet-inception-v1`: A generalist content classifier trained on ImageNet with 1000 output classes.
- `real-estate-v2`: A real estate tagging model that allow to automatically annotate images coming from a property ad with the room type, context of the photo and some typical objects appearing in the photo.
- `fashion-v4`: A detector that is able to localize fashion items in images.
- `furniture-v1`: A detector that is able to localize furniture in images.
- `weapon-v1`: A demo detector that is able to localize weapons in movies.
- `street-v1`: A demo detector that is able to localize pedestrians, cars, traffic signs and others in street scene images.

> To get a list of public recognition models, run:

```shell--curl
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

for spec in client.RecognitionSpec.list(public=True):
    print(spec)
```






### Accessing the list of labels

To access the list of labels for those classifiers, visit <a href="{{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/{:model_name}">{{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/{:model_name}</a> by replacing
`{:model_name}` with one of the IDs above.

For example, you can try to visit:
<a href="{{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/street-v1">{{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/street-v1</a>.

Please refer to [the inference section](#inference_reco_spec) for a complete description of the returned data.

> To access specifications of the model, including its output labels:

```shell--curl
MODEL_NAME="fashion-v4"
curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/${MODEL_NAME} \
{{ CURL_CREDENTIALS }}
```

```python--Python
MODEL_NAME="fashion-v4"
spec = client.RecognitionSpec.retrieve(model_name)
for label in spec['outputs'][0]['labels']['labels']:
    print("- {name} (id = {id})".format(name=label['name'], id=label['id']))
```




### Testing a model

You can run a recognition query on a test image from an URL, a file path, binary data, or base64 encoded data.
As our API is asynchronous, the inference endpoint returns a task ID. If you are trying the shell example, you might have to wait one second before trying the second `curl` command before the task completes.

> You can try your first recognition query from an URL by running:

```shell--curl
MODEL_NAME="fashion-v4"
TASK=`curl {{ VULCAIN_URL }}/{{ VERSION }}/recognition/public/${MODEL_NAME}/inference \
{{ CURL_CREDENTIALS }} \
-d '{"inputs": [{"image": {"source": "https://static.deepomatic.com/resources/demos/api-clients/dog2.jpg"}}], "show_discarded": false}' \
-H "Content-Type: application/json"`

# The curl result will return a task ID that we use to actually get the result
echo ${TASK}
TASK=$(echo ${TASK} | sed "s/[^0-9]*\([0-9]*\)[^0-9]*/\1/")
sleep 1
curl {{ VULCAIN_URL }}/{{ VERSION }}/tasks/${TASK} \
{{ CURL_CREDENTIALS }}
```

```python--Python
{{ PYTHON_CREDENTIALS }}

model = client.RecognitionSpec.retrieve("fashion-v4")

url = "https://static.deepomatic.com/resources/demos/api-clients/dog2.jpg"
model.inference(inputs=[deepomatic.ImageInput(url)], show_discarded=False)
```

The result of this command will be made of a JSON dictionnary `result` with one `outputs` field. This field will have one element as our public networks only have one interesting output tensor of type `labels`. So the fun really begins by looking at the value of `result['outputs][0]['labels']['predicted']` which is a list of object with the following fields:

- `label_name`: the name of the detected object.
- `label_id`: the numeric ID of the label corresponding to `label_name`.
- `roi`: a object containing a bounding box `bbox` localizing the position of the object in the image. The coordinates are normalized and the origin is in the top-left corner. Please refer to the [documentation](#prediction_region_id) of a description of `region_id`.
- `score`: the "confidence" score output of the softmax layer.
- `threshold`: the threshold above the confidence score is considered high enough to produce an output. If you set `show_discarded` to `True` in the query, you will also get in `result['outputs][0]['labels']['discarded']` a list of object candidates that did not pass the threshold.


> The output will be:

```json
{
    "outputs": [{
        "labels": {
            "predicted": [{
                "label_name": "sunglasses",
                "label_id": 9,
                "roi": {
                    "region_id": 1,
                    "bbox": {
                        "xmin": 0.312604159,
                        "ymin": 0.366485775,
                        "ymax": 0.5318923,
                        "xmax": 0.666821837
                    }
                },
                "score": 0.990304172,
                "threshold": 0.347
            }],
            "discarded": []
        }
    }]
}
```









## Preprocessing Examples

Please refer to the [documentation](#create_a_network) for an example of how to upload a network.
This operation involves defining of input images should be preprocessed via the `preprocessing` field. We give below some examples so such field:

### Typical preprocessing for a Caffe classification network:

```json
{
    "inputs": [
        {
            "tensor_name": "data",
            "image": {
                "resize_type": "SQUASH",
                "data_type": "FLOAT32",
                "dimension_order": "NCHW",
                "pixel_scaling": 255.0,
                "mean_file": "imagenet_mean.binaryproto",
                "target_size": "224x224",
                "color_channels": "BGR"
            }
        }
    ],
    "batched_output": true
}
```

### Typical preprocessing for a Caffe Faster-RCNN network:

```json
{
    "inputs": [
        {
            "tensor_name": "data",
            "image": {
                "resize_type": "NETWORK",
                "data_type": "FLOAT32",
                "dimension_order": "NCHW",
                "pixel_scaling": 255.0,
                "mean_file": "imagenet_mean.binaryproto",
                "target_size": "800",
                "color_channels": "BGR"
            }
        },
        {
            "tensor_name": "im_info",
            "constant": {
                "shape": [
                    3
                ],
                "data": [
                    "data.1",
                    "data.2",
                    1.0
                ]
            }
        }
    ],
    "batched_output": false
}
```

### Typical preprocessing for a Tensorflow inception v3 network:

```json
{
    "inputs": [
        {
            "tensor_name": "map/TensorArrayStack/TensorArrayGatherV3:0",
            "image": {
                "resize_type": "CROP",
                "data_type": "FLOAT32",
                "dimension_order": "NHWC",
                "pixel_scaling": 2.0,
                "mean_file": "unitary_mean.npy",
                "target_size": "299x299",
                "color_channels": "BGR"
            }
        }
    ],
    "batched_output": true
}
```

> The mean file "unitary_mean.npy" can be made this way:

```python
import numpy as np
mean = np.ones((1, 1, 3))  # HWC setup with H = 1, W = 1 and C = 3

with open('unitary_mean.npy', 'wb') as f:
    np.save(f, mean, allow_pickle=False)
```

### Typical preprocessing for a Tensorflow detection network:

```json
{
    "inputs": [
        {
            "tensor_name": "image_tensor:0",
            "image": {
                "resize_type": "NETWORK",
                "data_type": "UINT8",
                "dimension_order": "NHWC",
                "pixel_scaling": 255.0,
                "mean_file": "",
                "target_size": "500",
                "color_channels": "RGB"
            }
        }
    ],
    "batched_output": true
}
```






## Spec Output Examples

Please refer to the [documentation](#create_a_reco_spec) for an example of how to create a recognition specification. This operation involves defining `outputs` of your algorithms. We give below some examples of this field:

```python
def generate_outputs(labels, algo):
    return [{
        "labels": {
            "roi": "BBOX" if algo == "detection" else "NONE",
            "exclusive": algo != "tagging",
            "labels": [{"id": i, "name": l} for (i, l) in enumerate(labels)]
        }
    }]

# This generates `outputs` for classification (exclusive labels, softmax output)
outputs = generate_outputs(['hot-dog', 'not hot-dog'], 'classification')

# This generates `outputs` for tagging (non-exclusive labels, sigmoid output)
outputs = generate_outputs(['is_reptile', 'is_lezard'], 'tagging')

# This generates `outputs` for detection (exclusive labels)
outputs = generate_outputs(['car'], 'detection')
```




## Post-processing Examples

Please refer to the [documentation](#create_a_reco_version) for an example of how to create a recognition version.
This operation involves the `post_processings` field which defines how the output of the network should be handled.

In the post-processings proposed below, we omit the `thresholds` field on purpose: they will be set by default. The default value is:

- 0.025 for classification (`exclusive == True` and `roi == "NONE"` in the specification)
- 0.5 for tagging (`exclusive == False` and `roi == "NONE"` in the specification)
- 0.8 for detection (`roi == "BBOX"` in the specification)

### <a name="version_cheat_classif"></a> Typical post-processing for classification:

```json
{
    "classification": {
        "output_tensor": "inception_v3/logits/predictions"
    }
}
```

### <a name="version_cheat_anchored_detect"></a> Typical post-processing for an anchored detection algorithm

> This is typically a post processing for a Caffe Faster-RCNN implementation:

```json
{
    "detection": {
        "anchored_output": {
            "anchors_tensor": "rois",
            "scores_tensor": "cls_prob",
            "offsets_tensor": "bbox_pred"
        },
        "discard_threshold": 0.025,
        "nms_threshold": 0.3,
        "normalize_wrt_tensor": "im_info"
    }
}
```

### <a name="version_cheat_direct_detect"></a> Typical post-processing for a direct output detection algorithm:

```json
{
    "detection": {
        "direct_output": {
            "boxes_tensor": "detection_boxes:0",
            "scores_tensor": "detection_scores:0",
            "classes_tensor": "detection_classes:0"
        },
        "discard_threshold": 0.025,
        "nms_threshold": 0.3,
        "normalize_wrt_tensor": ""
    }
}
```


### <a name="version_cheat_yolo_detect"></a> Typical post-processing for a Yolo detection algorithm:

```json
{
    "detection": {
        "yolo_output": {
	        "output_tensor": "import/output:0",
            "anchors": [1.3221, 1.73145, 3.19275, 4.00944, 5.05587, 8.09892, 9.47112, 4.84053, 11.2364, 10.0071]
		},
        "discard_threshold": 0.025,
        "nms_threshold": 0.3,
        "normalize_wrt_tensor": ""
    }
}
```



