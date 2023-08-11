# <img src="https://user-images.githubusercontent.com/5237832/219489376-631bbccf-5a21-40d0-9dfa-7d026a17fa17.gif" width="150" height="150" />SVG Island <img src="https://user-images.githubusercontent.com/5237832/219489376-631bbccf-5a21-40d0-9dfa-7d026a17fa17.gif" width="150" height="150" />

notes:
mark
Welcome everyone, happy to have you all here. Today we're going to take a trip to SVG Island. This presentation won't be focused on a specific Elixir topic but don't fret there will be some Elixir code. This presentation will be very visual, kinda fast, and a bit silly. Let's get started. 

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
For MSP, the DR / Savings team needs to showcase to our customers the value GridPoint brings. This challenge brings us the opportunity to give our customers more insights into their consumption and savings while driving engagement to the platform. Let's see what design thinks.

---

### Design...Do your magic 🪄 
<img width="994" alt="CleanShot 2023-08-06 at 13 50 54@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/c182191b-3e1a-4fa9-8589-831a236b21dd">

notes:
mark
What a beauty. Here we see a chart with three bars for each month. The first bar shows how much this customer would have spent had they never signed up for GridPoint. The second bar shows how much this customer is currently spending while using the GridPoint service. The third bar is how much money the customer is savings because the signed up with GridPoint, or the difference between the first bar and the second.

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

Rule Number 2 NO JAVASCRIPT 🔥 

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
Given the no JavaScript constraint we're only considering pure elixir solutions. Unfortunately there's no D3 equivalent in the Elixir community. The most popular pure Elixir library is Contex. It supports bar charts, line plots, and even plays nicely with LiveView. Another interesting option is GGity as it's based on R's ggplot2 which provides a clean API for visualizations. Another library I looked at was VegaLite. If you're familiar with Livebook you've probably it seen it can draw some snazzy visualizations. However, VegaLite does have a JS dependency so let's take a closer look at Contex and GGity.

---

### Let's try Contex 🤞 
![Screen Shot 2023-01-30 at 4 41 56 PM](https://user-images.githubusercontent.com/5237832/215601888-98cb37be-2c49-4e06-8892-1899a0b02d2a.png)

notes:
mark
Here's a simple example of a multi-series bar chart built with Contex. This example was fairly easy to put together. Contex works by taking a dataset and some specific configuration about the chart then creates a chart struct. Once you have a struct you can use a Contex provided function to generate SVG based on the configuration of that struct. Let's see how our Contex spike lines up with design.

---

### What was that design again? 🤔 
<img width="994" alt="CleanShot 2023-08-06 at 13 50 54@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/c182191b-3e1a-4fa9-8589-831a236b21dd">

notes:
mark
Hmmmmm. Flip back to previous slide then back to this one. While it was pretty easy to get a bar chart from Contex the design is waaaay off.

---

### Ok.....Let's try GGity 🤞 
![Screen Shot 2023-01-30 at 4 42 11 PM](https://user-images.githubusercontent.com/5237832/215602696-32490af1-9cb3-456a-9dae-6d03450fab61.png)


notes:
mark
GGity works is much the same way as Contex. It takes a dataset and some specific configuration about the chart then creates a chart struct. Once you have a struct you can call a function that generates SVG. While have a more well rounded API, GGity suffers from the same constraints as Contex.

---

### 🙄 
![square_peg_round_hole](https://user-images.githubusercontent.com/5237832/215603097-28b2c26d-a61b-4768-898c-8adb2f09ee04.jpeg)

notes:
mark
I can't help but feel like I'm trying to fit a square peg in a round hole with these libraries. It's pretty straightforward to put a chart together but the customization and long term maintainability isn't there.

---

### Technical limitations 

- Both libraries ([Contex](https://github.com/mindok/contex), [GGity](https://github.com/srowley/ggity)) provide the charts we need.
- Missing needed customization for our use case.
- The libraries build data structures that in turn generate SVG charts.
- Alter the data structures or overwrite the SVG they generate to customize.

notes:
meks
What did we learn from spiking on these libraries? Both provide the charts we need, but lack the customization we would like to have for matching given designs. A commonality they have is that they build data structures to generate the SVG charts. Advanced customization would require use to alter the data structures or overwrite the generated SVGs, neither of which is ideal.

---

### Conclusion

- Build it ourselves.

notes:
meks
Our conclusion was that it would take more time and effort (in development and maintenance) to retrofit these charting libraries to our visualizations needs rather than simply doing it ourselves. Which brings us to...(flip to next slide) SVG Island! 

---

## ✈️ 🌴 SVG Island 🌴 

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

<img width="726" alt="CleanShot 2023-08-11 at 10 00 58@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/22ce1192-0067-4d44-9567-1212f9cec0e1">

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

<img width="735" alt="CleanShot 2023-08-11 at 10 01 36@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/3ef229f6-37eb-4e50-9903-989e63098b0c">

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

<img width="671" alt="CleanShot 2023-08-11 at 10 02 12@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/ec8a75e2-1188-4928-b20e-8aa3c2b0b6de">

![text_element](https://user-images.githubusercontent.com/5237832/219486890-92cdf1d4-a4c7-4285-8a4b-b8cee66e14ec.png)

notes:
mark

We're also gonna need the text element in order to add labels or other text to our chart.
Text works by adding a box of text at the given x, y coordinate.

---

![success_kid](https://user-images.githubusercontent.com/5237832/218855240-832a8182-b91a-4053-b400-674466f375b3.jpeg)

---

### Now that we got the basics down :muscle:
### Let's build a line chart 🏗️ 

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

![CleanShot 2023-08-06 at 15 16 26](https://github.com/gridpoint-com/svg_island/assets/60719697/09272d04-f787-470a-9040-b53904279521)

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

![CleanShot 2023-08-06 at 15 09 35](https://github.com/gridpoint-com/svg_island/assets/60719697/01c113e1-8130-4da7-a995-d9db0aa67dbd)

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

<img width="340" alt="CleanShot 2023-08-06 at 15 12 15@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/d256a9b8-dca6-419f-bf7e-5ea3442ef6d0">

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

![CleanShot 2023-08-06 at 15 23 37](https://github.com/gridpoint-com/svg_island/assets/60719697/719c243a-d0a1-4027-a5cf-7df4ff9ab857)

notes:

Meks: Let’s start the first line down where the 18k is. Put your pen to the
paper at that point, and drag upward at a slight right angle and stop at around
64k. Starting where you ended the previous line, draw a new line upwards and
stop at 72k. Starting where you ended that line, draw another one down 64k. We
would keep repeating this process for all the points we want to mark on the
line chart.

---

### Draw a line chart

<img width="833" alt="CleanShot 2023-08-06 at 15 25 59@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/f9e8a441-19a0-481f-a5c5-efd0e386dfe4">

notes: image of “line chart“

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

<img width="844" alt="CleanShot 2023-08-11 at 10 03 12@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/e6b3368e-c697-4fde-8b25-33a311ce1c78">

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

<img width="892" alt="CleanShot 2023-08-11 at 10 04 46@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/be8da5f3-0c51-4675-a7c9-e017009bdbf9">

notes:
Mark: The second big take away of this exercise is that I use my last known
location to keep drawing more lines. The end of the previous line becomes the
start of the next line. This let’s us algorithmically calculate coordinates to
draw lines based on the data points in the the dataset that we want to
represent.

---

### Jason Downloads

![jason_downloads_official](https://github.com/gridpoint-com/svg_island/assets/5237832/a263bf04-d378-410a-b030-a6e7f35d547d)

notes: Meks

image of official Jason Downloads chart

Most of us are probably familiar with Hex packages and have seen their download charts. We built a small demo app with the aim of replicating the Jason downloads chart. This demo is available publically. For anyone interested in seeing the code in it’s completed form, we’ll provide the link at the end.

---

### Jason Downloads

<img width="846" alt="Screenshot 2023-08-03 at 11 37 58 AM" src="https://github.com/gridpoint-com/svg_island/assets/60719697/ae7ce9f3-44ac-46f5-8616-aa9bcb296225">

<img width="525" alt="CleanShot 2023-08-11 at 10 07 28@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/5d0e2f33-bb28-490f-839a-3450db772e38">

notes:

image of unstyled Jason Downloads demo

What you see here on the screen is a hand built SVG replica. Every part was built using either polylines, or text elements. We took the data from the original chart, ran it through a transformation to create a list of structs that has the x and y coordinates for each line segment. The keys to this transformation lie in using the previous line’s end coordinates as the start of the current line and then using the dataset and dimensions of the SVG viewport to scale and determine the coordinates of the end of the line.

---

### Jason Downloads

<img width="831" alt="CleanShot 2023-08-03 at 15 40 36@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/30e3c631-ba10-41c4-82d2-6f169bdaba6e">

<img width="718" alt="CleanShot 2023-08-11 at 10 08 04@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/e5bfd5b3-b6b7-4a71-a688-3bd2f5fb4921">

notes:

image of styled Jason Downloads demo

Here is that same chart, but with styling applied. All this is done with just the required points attribute for the polyline and Tailwind classes! One of Tailwind's newer features is the "just-in-time" compiler which we take advantage of here. The JIT generates styles on-demand as templates are authored instead of generating everything in advance at initial build time. Since styles are generated on demand, we can add arbitrary styles without writing custom CSS using the square bracket notation. For the lines of the chart, we use this feature to style the SVG attributes of stroke width and the stroke linecap. This helped significantly with code readability and maintainability since we were able to exclusively use Tailwind for styling.

---

### Jason Downloads

<img width="553" alt="CleanShot 2023-08-11 at 10 08 28@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/fb91e7ee-eb05-45ea-bd7e-1a60dc12e749">

<img width="886" alt="CleanShot 2023-08-11 at 10 10 54@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/3f94f30a-c755-4d87-88ed-5b29e64ba03f">

notes:

The text elements for the y labels and the chart legend are similarly styled with Tailwind. A really helpful CSS trick is to use dominant-baseline and text-anchor attributes to position the text element relative to the coordinate. This allows us a bit more granularity with positioning the element without having to use magic numbers and adjust the coordinates themselves.

---

### Jason Downloads

![CleanShot 2023-08-03 at 15 50 58](https://github.com/gridpoint-com/svg_island/assets/60719697/0b60c0ad-1cc9-45a1-b968-05067ef39b6b)

<img width="858" alt="CleanShot 2023-08-11 at 10 11 27@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/b3674064-bda1-4a30-84f0-8c726aadc8fa">

notes:

gif of clicking on lines to show the tool tip

If you recall, we constrained our polylines to only have 2 points. What this allows us to do is interact with each line. We can add phx-click and click-away events to each polyline. The event handlers set the tooltip assigns and will display or hide the value from the dataset at the line’s end point.

---

### Updating the Chart with Assigns

https://github.com/gridpoint-com/svg_island/assets/60719697/40c51fc1-a3da-4b84-897c-ba0d6ce694fa

notes:

Updating the chart can be accomplished simply by adding a new datapoint into our socket assigns.
In this example we're receiving a message that contains our new datapoint and it's being assigned to the socket.
LiveView knows our data has changed so it redraws our chart and we see the new datapoint.
It's hard to tell but the entire chart is being redrawn on each message we receive.
I wonder if there's a way we could prevent an entire redraw on each message.

---

### Updating the Chart with Streams

https://github.com/gridpoint-com/svg_island/assets/60719697/97556769-fa4e-4331-bece-9daa9870d9d2

notes:

Here we have the same example but we're using LiveView Streams to update the chart instead of assigns.
On mount we add our existing data to the stream and on each message we insert the new datapoint into the stream.
Based on individual line IDs the stream is able to tell if it has drawn the line before or not.
What we end up with here is an live updating chart that only draws the new datapoint on each message it receives.

---

### How did we come up with this approach?

* Bottom up approach
* Hand crafted an SVG to match design
* Abstracted chart elements piece by piece

TODO bar_chart_component

notes:
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
Learning SVG isn't too bad but you do need to understand the basics to be proficient.
The hardest part is learning to think and visualize upside down.

We didn't have to add any new dependencies to our project and we're free to be creative
with our solutions.

We feel we can make our designers dreams come true but building these components in a way
such that they are maintainable and easy for other devs to understand will be an ongoing effort

---

### That's all folks

Slides / example project: https://github.com/gridpoint-com/svg_island

![cast_away_svg](https://github.com/gridpoint-com/svg_island/assets/5237832/19862d2c-2555-4b49-b5e4-b0108cf133c0)

