<!--
Video: Where on earth am I?
Creator: Matt Ashby
Source: https://www.youtube.com/watch?v=8L6EXiuckLo
Caption source: 8L6EXiuckLo.srt (downloaded English captions supplied by the author)
Prepared: 2026-10-03
Editorial changes: joined caption lines and grouped text into paragraphs.
Status: draft; wording retained from captions, not checked against audio or
reviewed for visual descriptions. Preserve the original SRT for review.
-->

I’m standing on Blackheath Common in south-east London. But if I wanted to tell someone my exact location, how would I describe it? I could say I was 500 metres south of Greenwich Observatory, but that would only be useful to people who know where the observatory is. I could use the address of the nearest building, but that’s several hundred metres away, so that wouldn’t be very accurate. One reliable way to describe where I am is to use a pair of co-ordinates.

Co-ordinates are numbers that specify a location on the earth’s surface relative to an agreed reference point. There are lots of different co-ordinate systems, but probably the best known is the geographic co-ordinate system, which uses latitude and longitude. That’s the system underlying every GPS-enabled device you own. Latitude is a measure of how far north or south of the equator a point is, while longitude is a measure of how far east or west a point is, relative to an imaginary line drawn through the Greenwich Observatory, which is just over there.

At the moment I’m standing exactly on that line, so my longitude is zero. The geographic co-ordinate system is used in lots of applications. But one difficulty with latitude and longitude is that they are usually measured in degrees. A latitude of zero means a location on the equator, while a latitude of plus ninety degrees means a location at the north pole. Right now I’m standing at fifty-one degrees north of the equator. But degrees aren’t very useful for measuring everyday distances – it’s not very informative to say that the nearest railway station is 0.01 degrees walk from here.

Because degrees of latitude and longitude aren’t easy to work with, it’s often easier to use a different type of coordinate system when making maps. These are called projected coordinate systems, and they work by specifying a location relative to a well-defined starting point. There are lots of different projected coordinate systems that cover different parts of the Earth’s surface. For example, for locations in London we can use the British National Grid system. This specifies locations based on how many metres east and north they are from a specific point in the Atlantic Ocean off the coast of Cornwall.

Because the British National Grid measures distances in metres, it is easier to work with. We will use co-ordinates specified in lots of projected co-ordinate systems during this course. But there is one draw-back of projected co-ordinate systems: the people who design them have to deal with the fact that maps are flat but the surface of the earth is curved. We don’t need to go into the mathematical details of how this is done, but it’s important to know that there is simply no way to accurately represent a curved surface on a flat map without some distortion.

There are lots of different ways to manage this problem. Which solution is best depends on the circumstances, so people designing projected co-ordinate systems for different parts of the globe will make different decisions. That has two consequences for us as map makers. Firstly, we must know which co-ordinate system a particular dataset uses. Knowing a pair of co-ordinates is useless unless we also know the co-ordinate system. Most spatial datasets have this information embedded in them, but if not then it’s vital that you find out what co-ordinate system the data uses.

One way to do that is to ask whoever provided the data what co-ordinate system they used. The second important point is that projected co-ordinate systems only work for the part of the globe that they were designed for. If you use the wrong co-ordinate system, or use a co-ordinate system for a different part of the world, it’s quite likely that your map will have errors in it or some of the features will look distorted.

For example, you probably recognise this outline of the UK. But if you told a computer to transform that outline using a co-ordinate system designed to make maps of Canada, you’ll see the outline becomes deformed. Dealing with co-ordinates can seem complicated, but they allow us to accurately identify locations on the earth’s surface. That’s a crucial step in being able to do useful things with spatial data – we will learn about many of those things during the rest of the course.

In summary: We use co-ordinates to describe locations on the Earth’s surface Different projected co-ordinate systems are used for different parts of the globe It is vital that we know which co-ordinate system a particular dataset uses
