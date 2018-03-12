# Common objects





<a name="point_object"></a>
## The point object

> ### Example of point object

```json
{
    "x" : 0.1,
    "y" : 0.1
}
```

A point is usally used to define a polygon in order to delimitate a non rectangle sub-part of the image. Coordinates are normalized to the image width and height. Origin is at the top-left corner.

Attribute | Type    | Description
--------- | ------- | -----------
x         | float   | x-coordinate of the point
y         | float   | y-coordinate of the point









<a name="bbox_object"></a>
## The bounding box object

> ### Example of bounding box object

```json
{
    "xmin": 0.1,
    "ymin" : 0.2,
    "xmax" : 0.8,
    "ymax": 0.9
}
```

A bounding box is a rectangle used to delimitate a sub-part of an image. Coordinates are normalized to the image width and height. Origin is at the top-left corner.

Attribute | Type    | Description
--------- | ------- | -----------
xmin      | float   | x-coordinate of the top of the bounding box
ymin      | float   | y-coordinate of the left of the bounding box
xmax      | float   | x-coordinate of the bottom of the bounding box
ymax      | float   | y-coordinate of the right of the bounding box






<a name="image_object"></a>
## The image object

> ### Example of image object

```json
{
    "url": "http://host.com/url_of_my_image",
    "bbox" {
        "xmin" : 0.1,
        "ymin" : 0.2,
        "xmax" : 0.8,
        "ymax": 0.9
    }
}
```

An image object is used to provide the input image to the various endpoints.

<aside class="notice">
You must not specify both 'url' and 'base64' fields. Only one of them is required.
</aside>

Attribute | Type    | Default | Description
--------- | ------- | --------| ------------
url       | string  |         | The url of the image
base64    | string  |         | The content of the image encoded in base64
polygon   | array(object)  | null | An array of [point objects](#point_object) of size at least 3 to crop the image
bbox      | object  | null    | A [bounding box object](#bbox_object) to crop the image







