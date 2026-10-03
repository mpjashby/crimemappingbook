<!--
Video: To make maps, think layers
Creator: Matt Ashby
Source: https://www.youtube.com/watch?v=fr0CPO9Ot9Q
Caption source: fr0CPO9Ot9Q.srt (downloaded English captions supplied by the author)
Prepared: 2026-10-03
Editorial changes: joined caption lines and grouped text into paragraphs.
Status: draft; wording retained from captions, not checked against audio or
reviewed for visual descriptions. Preserve the original SRT for review.
-->

When we make a map, we are trying to convey some information about a part of the real world. But every part of the world contains far more detail than we could ever convey easily on a map, not least because maps always show the world at a smaller scale than it really is. The infinite detail of the real world means that it can sometimes be challenging to manage all the data we want to include on a map.

In fact, to make any map we have to simplify the real world. One way to do that is to think of the world as being made up of different types of features. A feature could be something from the physical world, such as the outline of a building, the course of a street, or the location of a tree. A feature could also be a an event that happened in a particular place, such as the location of an individual crime.

There are infinite types of features that we could put on maps, but computers typically store individual features in three different ways: as points, as lines or as polygons. Points are used to represent physical features such as street lights, as well as the locations of individual events. Lines are used to represent physical features such as walls and roads, as well as behavioural features such as routes from one place to another. Polygons are used to represent features like the outline of a building or the area covered by a police force.

Most files that store spatial information can only store points, lines or polygons – not a mixture of different types. That means it’s usual for information about different types of feature to be stored in different files. For example, if we wanted to find the nearest police station to a set of crime locations, we would probably have a dataset of police station locations and a separate dataset of crime locations. Once we have all the data we need, we can build a map by adding each type of feature as a separate map layer.

Every map is made up of multiple layers of data, stacked on top of one another. For example, we might have a layer representing roads, another representing buildings, and so on. It can be easy to end up trying to show a lot of data on a map, either because the map shows a large area or because it shows a lot of detail. Eventually the amount of data becomes hard to work with. If that happens we can simplify the data by converting the points, lines or polygons on the map into a raster layer.

A raster layer is made up of a grid of cells – sometimes called pixels – with each cell having a single value associated with it. In this course we will see several examples of raster layers on maps. The first are called base maps, which show all the different physical features in an environment as a single layer. Base maps like this one can be very useful because they mean we don’t have to deal with separate layers for every type of feature we want to show on a map.

But because we can’t access each feature individually, we cannot easily choose what information is shown on a base map, or how features are represented. That means it’s important to choose a base map that shows the information we need in a clear way. Fortunately, there are lots of useful base maps available online. To summarise: Spatial data can be represent as points, lines or polygons We can build maps by stacking layers of features on top of each other We can represent features as rasters to make them easier to work with
