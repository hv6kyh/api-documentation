# Common objects



<a name="input_object"></a>
### Input Object

The input object describes the data to send as input to the network. You must specify exactly one key among the possible input types. Currently only the image inputs are supported.

Parameter      | Type          | Default | Description
-------------- | ------------- | ------- | -----------
image          | [object](#image_input_object) |         | An image input.

<a name="image_input_object"></a>
**Image Input Object**

Attribute   | Type    | Description
----------- | ------- | -----------
source      | string  | May have various forms: <ul><li>The URL of the image</li><li>The base64 encoded content of the image prefixed by `data:image/{:format};base64,`.</li><li>The binary content of the image prefixed by `data:image/{:format};binary,`</li></ul> In the two last cases, `{:format}` is the image format (jpeg, png, etc...). If you don't know about the format just use `*`.
bbox        | [object](#bbox_object)  | A [bounding box object](#bbox_object) to crop the image.
polygon     | array([object](#point_object)) | An array of [point objects](#point_object) of size at least 3 to crop the image.
crop_uniform_background  | bool | If true, an image depicting a foreground in front of a uniform background will be cropped arond the foreground (useful for marketplace images)








<a name="point_object"></a>
## The point object

A point is usally used to define a polygon in order to delimitate a non rectangle sub-part of the image. Coordinates are normalized to the image width and height. Origin is at the top-left corner.

Attribute | Type    | Description
--------- | ------- | -----------
x         | float   | x-coordinate of the point
y         | float   | y-coordinate of the point

> **Example of point object**

```json
{
    "x" : 0.1,
    "y" : 0.1
}
```







<a name="bbox_object"></a>
## The bounding box object

A bounding box is a rectangle used to delimitate a sub-part of an image. Coordinates are normalized to the image width and height. Origin is at the top-left corner.

Attribute | Type    | Description
--------- | ------- | -----------
xmin      | float   | x-coordinate of the top of the bounding box
ymin      | float   | y-coordinate of the left of the bounding box
xmax      | float   | x-coordinate of the bottom of the bounding box
ymax      | float   | y-coordinate of the right of the bounding box

> **Example of bounding box object**

```json
{
    "xmin": 0.1,
    "ymin" : 0.2,
    "xmax" : 0.8,
    "ymax": 0.9
}
```
