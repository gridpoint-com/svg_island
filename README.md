# <img src="https://user-images.githubusercontent.com/5237832/219489376-631bbccf-5a21-40d0-9dfa-7d026a17fa17.gif" width="150" height="150" />SVG Island <img src="https://user-images.githubusercontent.com/5237832/219489376-631bbccf-5a21-40d0-9dfa-7d026a17fa17.gif" width="150" height="150" />

notes:
mark

Welcome everyone, happy to have you all here. By the dancing trees you can see we're about to take a trip to SVG Island. This presentation isn't focused on a specific Elixir topic but instead takes you on our journey of developing custom SVG charts for use in Phoenix LiveViews. Let's get started.

---

### Intro Presenters 👯 
notes:
meks

I’m Meks, they/them pronouns, and I have been working on the Commissioning & Installation team at GridPoint for a year.
This is Mark, he has been on the Demand Response & Savings team at GridPoint for the past year.
We both joined GridPoint when they were switching over their main product platform to Elixir and Phoenix. The goal is to use Elixir to accelerate a sustainable energy future through improving small business energy efficiency. Our teams all highly value collaboration which is why I was able to leave my domain for a bit to help Mark with a particular challenge.

---

### Why? :palm_tree: SVG Island :palm_tree:

notes:
mark

One of GridPoint's big selling points is that it actually saves you money. The savings team needed a way to showcase to our customers the value GridPoint brings. This challenge brings us the opportunity to give insights into energy consumption and savings data. Let's see what design thinks about this problem.

---

### Design...Do your magic 🪄 
<img width="992" alt="CleanShot 2023-08-06 at 13 51 17@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/dabb5784-68c7-466e-8726-28735b22ba69">

notes:
mark

Wow, what a beauty. This bar chart gives our customers insights into how much they're savings by using GridPoint. The blue line represents how much this customer would have spent had they never signed up for GridPoint. The teal line shows how much the customer is currently spending. The green line shows how much the customer is saving.

---

# 😍 

notes:
meks

We love our designers don't we.

---

### Let's build it 🚧 

Rule Number 1 No Javascript 🔥 

notes:
meks

First, let’s lay some ground rules. GridPoint is trying to build the product with as few dependencies as possible, relying on the tools provided by Elixir, Phoenix, and the BEAM. At the time, the only Javascript in the project came from the Phoenix.LiveView.JS library. One of the constraints we were given was to do as much as possible with the built in LiveView functionality. So, no Javascript.

---
### Let's build it 🚧 

Rule Number 2 No Javascript 🔥 

notes:
meks

Yeah, the higher ups were pretty serious about that.

---

### Elixir Charting Libraries 🧐 

[Contex](https://github.com/mindok/contex)

[GGity](https://github.com/srowley/ggity)

[VegaLite](https://github.com/livebook-dev/vega_lite) 

notes:
mark

Given the no JavaScript constraint we're only considering pure elixir solutions. Unfortunately there's no D3.js equivalent in the Elixir community. After looking around to see what's our there we decided to try out Contex and GGity. VegaLite was another one and if you're familiar with LiveBook you've probably seen its snazzy visualizations. VegaLite only works with LiveBook and does have a JS dependency so let's take a close look at our other options.

---

### Contex 🤔 

#### Pros
* Most popular pure Elixir charting library
* Works well with LiveView
* Support for many chart types

#### Cons
* Documentation
* Output SVG is complex
* No clear way to meet our design goals


notes:
mark

Contex is the most popular pure Elixir charting library. It supports bar chart, line plots, and even plays nicely with LiveView. It supported multi-series chart which was a requirement for us. The downsides were the documentation, complexity of the output SVG, and no clear way to meet our design goals.

---

### GGity 🤔 

#### Pros
* Based on R's ggplot2 API with great documentation
* Works well with LiveView
* Support for many chart types

#### Cons
* API is less intuitive an Contex's
* Styling is more "scientific" looking
* No clear way to meet our design goals


notes:
mark

GGity is quite interesting as it's based on R's ggplot2 which folks in the scientific community might be aware of. Like Contex works with LiveView and has support of the chart types we need. Still though there was no clear way to meet our design goals with this library.

---

### Technical limitations 

- Both libraries build data structures that in turn generate SVG charts
- We could alter data structures to meet our goals
- We could overwrite the output SVG to meet our goals

notes:
meks

What did we learn from spiking on these libraries? Both provide the charts we need but lack the customization needed to achieve our design goals. A commonality they have is that they build data structures that SVG is generated from. Advanced customization would require use to alter the data structures or overwrite the generated SVGs, neither of which is ideal.

---

### Conclusion

- Build it ourselves.

notes:
meks

Our conclusion was that it would take more time and effort (in development and maintenance) to retrofit these charting libraries to our visualizations needs rather than simply doing it ourselves. Which brings us to...(flip to next slide) SVG Island! 

---

## ✈️ 🌴 SVG Island 🌴 

notes:

---

### What is SVG? 🤔 
- **[SVG](https://developer.mozilla.org/en-US/docs/Web/SVG)**: Markup language for describing two-dimensional based vector graphics.
- **[Vector Graphic](https://en.wikipedia.org/wiki/Vector_graphics)**: Visual images created from geometric shapes on a Cartesian plane
- **[Element](https://developer.mozilla.org/en-US/docs/Web/SVG/Element)**: Used to create drawings and images.
- **[Attribute](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute)**: Used to modify how an element should be handled or rendered.
- [An SVG Primer](https://www.w3.org/Graphics/SVG/IG/resources/svgprimer.html) for the curious.

notes:
meks

SVG, or Scalable Vector Graphic, is a markup language for describing 2 dimensional vector graphics. Vector graphics is a form of computer graphics in which visual images are created directly from geometric shapes such as points, lines, curves and polygons. Elements such as polyline and text are used together to create visuals. And attributes such as fill and stroke modify those elements.

---

### Let's go over the basics 🧐 

notes:

---

### First we define a ViewBox
**[ViewBox](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/viewBox)**: Defines the position and dimension, in user space, of an SVG viewport.

<img width="730" alt="CleanShot 2023-08-11 at 10 00 06@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/5f8f4458-0a3d-4336-929b-1715f4c84cad">

![empty_viewBox](https://user-images.githubusercontent.com/5237832/218849904-91f3d1f1-6140-48b8-9d47-dc5f6b0a7182.png)

notes:
mark

The viewbox is our playground and the space we'll work in to draw SVGs. 
Here I've defined a viewbox with an origin point of 0,0 and an arbitary width and height.
I've used my browsers inspect here to outline the viewbox.

---

### Outline the ViewBox

<img width="726" alt="CleanShot 2023-08-11 at 10 00 58@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/1a9e8d78-22b6-4747-b641-f4ae2160f5c4">

![viewbox_outline](https://user-images.githubusercontent.com/5237832/218851323-37e48f88-131c-4b25-9609-f6a333b43fb0.png)

notes:
mark

While working with SVGs it can be helpful to use rectangles to outline the space you're working in.

Here I've used the rectangle element with 100% width and height to actually SEE the viewbox.

This is the `IO.inspect` of SVG.

---

### Recall Geometry
<img src="https://user-images.githubusercontent.com/5237832/219403192-0deb8989-5b4a-4512-9a03-32e7639a224f.png" alt="cartesian coordinate system" style="height: 400px; width:400px;"/>

notes:
meks

Reaching back into the recesses of my brain, back in highschool we studied Geometry and studied the Cartesian coordinate system.

The top right quadrant, positive x, positive y, is the quadrant applicable to SVG creation. This is how the vector graphics are created, by drawing shapes using a coordinate system.

Note the origin (0, 0) is in the bottom left corner of quadrant 1.

---

### SVG Coordinate System 🙃
![svg_coordinate_system](https://user-images.githubusercontent.com/5237832/218846599-b12d28d7-7e40-4c89-b41e-29968878eb2f.png)

notes:
meks

The SVG coordinate system is similar to quadrant 1 of the Cartesian coordinate system except the origin (0,0) is in the top left corner.
The y-axis is reversed compared to a normal graph coordinate system. As y increases in SVG, the points, shapes etc. move down, not up.
Many computer graphics programs rely on this type of system, as it allows the origin to be at the top left of the browser screen.
This was one of the most challenging parts of building our own charts and I regularly had to stop and think about this.
It really helped to pause and perform the mental gymnastics of visualizing what the chart needs to look like and inverting the y coordinates in relationship to the y values that needed to be displayed.

---

### Our bread and butter 🧈
**[Polyline](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/polyline)**: Creates straight lines connecting several points.

<img width="735" alt="CleanShot 2023-08-11 at 10 01 36@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/b15061cc-90f6-425b-aebd-d2c85d63cc16">

![polyline](https://user-images.githubusercontent.com/5237832/218853849-c169972a-25b3-4846-b6b3-10e20ac21405.png)

notes:
mark

Polyline is our main SVG element and what we'll use to draw the chart.
Polyline works by accepting a list of x,y coordinates which it then connects together to form a line.
Polyline accepts an arbitary number of points but more on that later.
Here I'm using a Polyline to draw a line from the bottom of the viewbox to the top of the viewbox.

---

### The other element
**[Text](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/text)**: draws a graphics element consisting of text.

<img width="671" alt="CleanShot 2023-08-11 at 10 02 12@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/a24e7758-2e50-461d-b147-0a99a7f6b1d4">

![text_element](https://user-images.githubusercontent.com/5237832/219486890-92cdf1d4-a4c7-4285-8a4b-b8cee66e14ec.png)

notes:
mark

We're also gonna need the text element in order to add labels or other text to our chart.
Text works by adding a box of text at the given x, y coordinate.

---

### Now that we got the basics down :muscle:
### Let's build a line chart 🏗️ 

notes:
notes

---

### Draw a straight line

notes:

Mark: Meks, I have a challenge for you.
Meks: You do?
Mark: Yeah.
Meks: Ok. What is it?
Mark: Explain to me how to draw a straight line. Pretend I am 5 years old, have
never drawn a straight line before, and am using pen and paper.
Meks: Really?
Mark: It’ll make sense, trust me.
Meks: Ok, one way that comes to mind is that you pick a point to start at.
Press your pen to the paper, drag your pen horizontally across the paper, and
lift up your pen from the paper when the line is as long as you want.

---

### Draw a straight line

![CleanShot 2023-08-06 at 15 16 26](https://github.com/gridpoint-com/svg_island/assets/60719697/a8003230-1ddc-41e8-b92e-2789457e115c)

notes:

Mark: Like this?
Meks: Yeah, that’s a straight line.
Mark: Nice!

---

### Draw an “M”

notes:

Mark: I have another challenge.
Meks: Bring it on.
Mark: How would I draw a capital ”M“. Explain it to me like I’m 5,
have only ever drawn a straight line before, and am using pen and paper.
Meks: That’s a bit harder, but if we use the concept established with how we
can draw a straight line, it’s not so bad.

---

### Draw an “M”

![CleanShot 2023-08-06 at 15 09 35](https://github.com/gridpoint-com/svg_island/assets/60719697/39ec0c40-e67d-4321-b23a-8faaa8d04a0d)

notes:
meks 

Pick a point to start at the bottom of the M. Extend the line to the
height of the M with a slight slant to the right.
From the end of the previous line, draw a line downwards that's half the height
of the previous line.
From the end of the previous line, draw a line that rises half the height of
the letter M.
From the end of the previous line, draw a line downwards that's the height of
the letter M with a slight slant to the right.

---

### Draw an “M”

<img width="340" alt="CleanShot 2023-08-06 at 15 12 15@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/a6832f63-5b3a-44ba-a440-9ca596767af6">

notes:

Mark: Like that?
Meks: Yup! Looks like an M do me. Did you pick M because both our names start
with that letter?
Mark: Moving on...

---

### Draw a line chart

notes:

Mark: I have a final challenge. Last one I promise. Explain to me how to draw a
line chart. I’m 5 years old, have only drawn an M before, and I’m using pen and
paper.

---

### Draw a line chart

![CleanShot 2023-08-06 at 15 23 37](https://github.com/gridpoint-com/svg_island/assets/60719697/e7515a9b-08dd-424b-b827-a420d3454361)

notes:

Meks: Let’s start the first line down where the 18k is. Put your pen to the
paper at that point, and drag upward at a slight right angle and stop at around
64k. Starting where you ended the previous line, draw a new line upwards and
stop at 72k. Starting where you ended that line, draw another one down 64k. We
would keep repeating this process for all the points we want to mark on the
line chart.

---

### Draw a line chart

<img width="833" alt="CleanShot 2023-08-06 at 15 25 59@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/f2464b61-cbd6-484a-ace6-61da7aa415d6">

notes: 

Mark: Like so?
Meks: Yup! That’s a line chart! I think I see where you are going with this.
What we just described, is essentially an algorithm that we can use. We have
established a repeatable pattern for how a chart is drawn, which means that we
can translate that into Elixir code.

---

### What’s the point?

* We have many points! And we connect them!

notes:

Meks: So what was the point of that exercise? Well we have many points, and we connect them!
Mark: Really?
Meks: Sorry, bad pun, I couldn’t help myself.

---

### Important Point 1 

* Constrain polyline to only accept 2 points

<img width="844" alt="CleanShot 2023-08-11 at 10 03 12@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/48bd84eb-1989-4328-a5af-6250c9f7d557">

notes:

Meks: The crux is that we have two points, the start and the end of the line.
This is important for our use case because we constrain the use of the polyline
to only accept two points. We do this by creating a functional component that
accepts exactly two sets of x and y coordinates. This was a conscious choice we
made because then each line segment represents a piece of data that we can
interact with.

---

### Important Point 2 

* Side effect of point 1, constraining polyline to 2 points
* Utilize last known location to keep drawing more lines
  
<img width="892" alt="CleanShot 2023-08-11 at 10 04 46@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/06666f01-312e-4c8d-9a9d-22439b1c249b">

notes:

Mark: The second big take away of this exercise is that I use my last known
location to keep drawing more lines. The end of the previous line becomes the
start of the next line. This let’s us algorithmically calculate coordinates to
draw lines based on the data points in the the dataset that we want to
represent.

---

### Jason Downloads

![jason_downloads_official](https://github.com/gridpoint-com/svg_island/assets/5237832/a263bf04-d378-410a-b030-a6e7f35d547d)

notes: 

Meks

Most of us are probably familiar with Hex packages and have seen their download charts. We built a small demo app with the aim of replicating the Jason downloads chart. This demo is available publicly. For anyone interested in seeing the code in it’s completed form, we’ll provide the link at the end.

---

### Jason Downloads

<img width="525" alt="CleanShot 2023-08-11 at 10 07 28@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/967efda6-d575-4958-9ddd-c98d600f0146">

<img width="846" alt="Screenshot 2023-08-03 at 11 37 58 AM" src="https://github.com/gridpoint-com/svg_island/assets/60719697/13ae1af7-5cf3-40dc-9019-ee83a866827b">

notes:

Meks

What you see here on the screen is a hand built SVG replica. Every part was built using either polylines, or text elements. We took the data from the original chart, ran it through a transformation to create a list of structs that has the x and y coordinates for each line segment. The keys to this transformation lie in using the previous line’s end coordinates as the start of the current line and then using the dataset and dimensions of the SVG viewport to scale and determine the coordinates of the end of the line.

---

### Jason Downloads

<img width="831" alt="CleanShot 2023-08-03 at 15 40 36@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/5b442340-41b4-4add-8d66-6e3f4dfeb5c9">

notes: Meks

Here is that same chart, but with styling applied. All this is done with just the required points svg attribute for the polyline and Tailwind CSS classes!

---

### Tailwind CSS

- JIT: “just-in-time” compiler
- Add arbitrary values `stroke-[3]`
- Add additional CSS attributes `[stroke-linecap:round]`

notes:

Meks
A brief intro to Tailwind, it is a utility-first CSS framework for building websites without ever leaving your HTML, or in our case our HEEX templates. One of Tailwind's newer features is the "just-in-time" compiler which we take advantage of here to style SVG elements. The JIT generates styles on-demand as templates are authored instead of generating everything in advance at initial build time. Since styles are generated on demand, we can add arbitrary styles without writing custom CSS using the square bracket notation. 
 
---

### Tailwind CSS

<img width="504" alt="CleanShot 2023-08-17 at 20 48 35@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/d3bae18f-96ea-4e6d-ae64-0d16835a0920">

notes:

Meks
For the lines of the chart, we use this feature to style the SVG attributes of stroke width and the stroke linecap. Since Tailwind has the stroke width attribute, notated as stroke, but only values of 0-2px, we can use the square bracket notation to tell it to have an arbitrary value of 3px. Stroke-linecap is an svg attribute that describes how the end of the line should look. A value of round gives us that nice connection between the polylines. But, stroke-linecap doesn’t exist in the Tailwind library, so we can again use the square bracket notation to inline additional CSS.

---

### Tailwind CSS

<img width="683" alt="CleanShot 2023-08-17 at 20 49 26@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/8eba22ae-8662-4301-b8ca-7fcbc9c0ab81">

<img width="860" alt="CleanShot 2023-08-17 at 16 29 09@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/62914bc1-00e4-4191-ade7-52bb724c81b9">

notes: 

Meks

Here you can see how straight forward it is to just switch out a few values to change the line width, opacity, and linecaps. A big advantage with this is that we didn’t have to leave the LiveView to go and write vanilla CSS in another file. This helped significantly with code readability and maintainability since we were able to exclusively use inline Tailwind for styling. It also helped us as developers to be responsive to changes requested by design.

---

### Positioning Text Elements

<img width="771" alt="CleanShot 2023-08-17 at 15 25 16@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/99f191a0-c364-4812-a869-e4eac7cccf2f">

<img width="487" alt="CleanShot 2023-08-17 at 15 24 13@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/dab6f7f9-9a03-4ec2-84f2-82923572b91f">

notes: 

Meks

So we have pretty well established how to draw lines in relation to each other and the dimensions of the viewbox. We also know how to style them, but what about the text elements like the labels and the legend? Let’s look at the legend to see how we can position that. Here we have a small functional component where we can pass it the coordinates and value of the text for the legend. We’ll use the chart width and height to determine its placement. Remember, SVG charts are upside down, so to place it in the upper most part of the chart, we just use y=0. We can pass x={@chart.dimensions.chart_width} for its x coordinate.

---

### Positioning Text Elements

<img width="566" alt="Screenshot 2023-08-17 at 3 21 00 PM" src="https://github.com/gridpoint-com/svg_island/assets/60719697/95c9a476-3303-4aa9-ad5b-372eb3dec27b">

notes: 

Meks

But…what happened? This is where turning on debug mode to see the outline of the viewbox in tandem with the browser inspect comes in handy. The legend is outside the bounds of the viewbox. When you set coordinates to position SVG text, you’re setting the location of the left edge of the text and the baseline of the font, so the bottom. So that means the bottom of the text is at y=0 and the left edge is at the width of the viewbox. We can fix this by giving it some magic numbers and make its origin not the full width of the viewbox and remembering that to move it down we need to increase its y value.

---

### Positioning Text Elements

<img width="569" alt="CleanShot 2023-08-17 at 15 12 18@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/f7594857-6cc0-4efb-b78b-1964164216e5">

<img width="420" alt="CleanShot 2023-08-17 at 15 28 47@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/6db72464-3aec-46ff-8f0f-b15f98f71e2f">

notes: 

Meks

While this works, it’s not ideal since that position will need to change based on the contents of the text element. And we would like this to be a bit more flexible. I wonder if we can do away with these magic numbers?

---

### Positioning Text Elements with Tailwind

<img width="799" alt="CleanShot 2023-08-17 at 15 33 00@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/3d835f7b-3949-4de8-a4fb-15c56be203ca">

<img width="424" alt="CleanShot 2023-08-17 at 15 32 13@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/771077b8-dc7e-4467-a99a-c623a1a79ae9">

notes: 

Meks

Well. With Tailwind, we can! Once again, we rely on the just-in-time compiler and add some SVG attribute references that the Tailwind library doesn’t contain; dominant-baseline and text-anchor. We can change the text location relative to the coordinate with these SVG specific attributes. By setting the dominant-baseline attribute to hanging, we move the text below the baseline which is at y=0. Then to move the text to the left and back inside our viewport we can use text-anchor which lets us align the text horizontally. By giving it “end”, we’re telling it to align the end of the text with the coordinate we gave it. For any other CSS nerds, the end of the presentation will have links to an excellent blog series that gets into the specifics of how this works and the many different values these attributes accept.

---

### Jason Downloads

![CleanShot 2023-08-03 at 15 50 58](https://github.com/gridpoint-com/svg_island/assets/60719697/a7c3be78-a4eb-4c99-bc97-be43c7c58ffa)

<img width="858" alt="CleanShot 2023-08-11 at 10 11 27@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/1b45fdbe-096f-4a8f-af2d-d2990637e91d">

notes: 

Meks

Going back to our download chart, if you recall, we constrained our polylines to only have 2 points. What this allows us to do is interact with each line. We can add phx-click and click-away events to each polyline. The event handlers set the tooltip assigns and will display or hide the value from the dataset at the line’s end point.

---

### Updating the Chart with Assigns

![CleanShot 2023-08-11 at 09 54 36](https://github.com/gridpoint-com/svg_island/assets/60719697/08a5fd13-b1b4-416c-9d56-e803e270853a)

notes: 

Mark

Next you might be wondering, what about updating the chart with new data? Well updating a chart is no different than other updates we'd do with LiveView. The above example is showing what it looks like to update the chart with socket assigns. When we receive a new datapoint the coordinates are generated for it then added to the socket assigns. It's quite hard to tell but on each update there's a roundtrip to the server and an entire redraw of the chart. I wonder if there's a way we could prevent this?

---
###  Intro LiveView Streams
* Streams are a mechanism for managing large collections on the client without keeping the resources on the server

notes:
Mark

Here come LiveView Streams to the rescue. If you haven't heard streams are a new mechanism for managing large collections on the client without keeping the resources on the server. Streams has an elegant interface to insert and delete items from a client side collection.


---
### Why LiveView Streams

* Chart is a client-side collection
* Avoid round-trips to the server
* Avoid redrawing the entire chart

notes:

Mark
In essence a chart is a client side collection as it manifests as a visualization. Pushing the chart coordinates into a stream allows us to insert new datapoints without having to roundtrip to the server or redraw the entire chart.

---
### Implementing LiveView Streams

![implement_streams_1](https://github.com/gridpoint-com/svg_island/assets/5237832/d615800f-0e7c-466a-a3c0-6c8a8d543c7d)
![implement_streams_2](https://github.com/gridpoint-com/svg_island/assets/5237832/4e810b95-473e-4dcd-b09e-64284909fe7d)
![implement_streams_3](https://github.com/gridpoint-com/svg_island/assets/5237832/37a97893-95c1-40c5-a2df-8f6418078127)

notes:

Mark
Well given all these benefits for our use this must be super hard to implement. Actually in 3 simple steps we can take our existing functionality and get it working with streams. First, we add our chart line coordinates to a stream on our LiveView's mount. Second, we use stream_insert to add the latest_line into our stream. Third, we change our comprehension to iterate over the stream instead of socket assigns.


---

### Updating the Chart with Streams

![CleanShot 2023-08-11 at 09 52 29](https://github.com/gridpoint-com/svg_island/assets/60719697/08056873-8d49-41a3-a914-aaa219f1da60)

notes: 

Mark

TADA we now have our chart updating with LiveView streams! In the image above you can see that we're assign a unique ID to each with its datapoint and coordinates. You can see in the logs that only the new datapoint is shown in the logs. Streams is able to use these unique IDs to determine if it has drawn the line before or not. Pretty neat!

---

### How did we come up with this approach?

* Bottom up approach
* Hand crafted an SVG to match design
* Abstracted chart elements piece by piece
  
<img width="340" alt="CleanShot 2023-08-14 at 13 57 11@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/bf52ae19-6be5-4a06-a308-4fb628ed069d">

notes:

Mark 

Now that you know our approach, you're probably wondering how we came up with it

Our first chart was a Bar Chart and we took a bottom up approach to building it
By bottom up I mean we had a design and hand crafted an SVG to match it

Once we had a styled, hard coded SVG, we began to abstract the chart piece by piece 
Abstract the background lines, abstract the labels, abstract the bar lines

After all this we had a fully abstracted bar chart comonent that we could pass data into

---

### What didn't go well with this approach?

* Scaling the chart data
* Access to the coordinates
* Elements of the chart drawn independently

![bar_chart_tooltip](https://github.com/gridpoint-com/svg_island/assets/5237832/30dbae86-891d-4ef2-8731-385d72ace694)

notes:

Mark

So we have built this component such that it accepts a certain set of data and abstracted away a lot of the complexity
We did run into a few minor problems when we plugged real data into it

The first issue was that we had to scale the data such lines were the proper length 
and didn't go outside the bounds of the chart

The second issue we had was in regards to click events, 
when a user clicks on a line the coordinates of line are pushed to the LV

When we went to display the tooltip we could only place the tooltip relative to the line that was clicked
We were not able to place the tooltip where design wanted and it brought up a bigger issue with the overall component
The coordinates were generated on render and were not stored or accessible to the user of component

All aspects of the chart were drawn indepently, causing alignment issues among the various elements of the chart
fixing these alignment issues lead to a few "magic" numbers to get everything lined up perfectly

---

### What would we do differently?

* Start top-down with the data
* Stateful component with access to coordinates
* Made use of SVG attributes for alignment

notes:

Mark

Start with a top down, data driven approach. 
This way you build only what you need to display the data and nothing more

Have the coordinates accessible to the user of the component, potentailly a stateful LV component
This would allow you complete flexible when adding, changing, or reacting to events

There are a few SVG attributes that solve a lot of the alignment issues we ran into.
For example, move the positioning of a label relative to other elements
These SVG attributes can be applied the same way we apply tailwind clases

---

### Would we recommend doing this?

* Learning SVG isn't too bad
* We didn't introduce a JS dependency
* Great power, great responsibility

notes:

Mark

Learning SVG isn't too bad but you do need to understand the basics to be proficient.
The hardest part is learning to think and visualize upside down.

We didn't have to add any new dependencies to our project and we're free to be creative
with our solutions.

We feel we can make our designers dreams come true but building these components in a way
such that they are maintainable and easy for other devs to understand will be an ongoing effort

---

### That's all folks

Slides / example project: https://github.com/gridpoint-com/svg_island

[How to work with SVG text](https://vanseodesign.com/web-design/how-to-work-with-svg-text/)

![cast_away_svg](https://github.com/gridpoint-com/svg_island/assets/5237832/19862d2c-2555-4b49-b5e4-b0108cf133c0)
notes:

Mark

That's all folks. You can find these slides and an example project at the link above. And oh yeah, here's a photo of me on SVG Island. Thanks for attending.