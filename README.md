# <img src="https://user-images.githubusercontent.com/5237832/219489376-631bbccf-5a21-40d0-9dfa-7d026a17fa17.gif" width="150" height="150" />SVG Island <img src="https://user-images.githubusercontent.com/5237832/219489376-631bbccf-5a21-40d0-9dfa-7d026a17fa17.gif" width="150" height="150" />

notes:
mark
Welcome everyone, happy to have you all here. Today we're going to take a trip to SVG Island. This presentation won't be focused on a specific Elixir topic but don't fret there will be some Elixir code. This presentation will be very visual, kinda fast, and a bit silly. Let's get started. 

---

### Intro Presenters 👯 
notes:
meks
_Intro Mark, Meks, and teams, cross team collaboration_

---

### Why? :palm_tree: SVG Island :palm_tree:

notes:
mark
For MSP, the DR / Savings team needs to showcase to our customers the value GridPoint brings. This challenge brings us the opportunity to give our customers more insights into their consumption and savings while driving engagement to the platform. Let's see what design thinks.

---

### Design...Do your magic 🪄 
![figma_bar_chart](https://user-images.githubusercontent.com/5237832/215600262-3d994826-7b93-4a81-a6f1-0598381c487f.png)

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

Rule Number 2 NO JAVASCRIPT 🔥 

notes:
meks

consider breaking apart over many slides and ping pong back and forth

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
![figma_bar_chart](https://user-images.githubusercontent.com/5237832/215600262-3d994826-7b93-4a81-a6f1-0598381c487f.png)

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

- Both libraries ([Contex](https://github.com/mindok/contex), [GGity](https://github.com/srowley/ggity)) provide the charts we need but lack the customization we're looking for.
- These libraries build data structures that in turn generate SVG charts.
- To customize we'd have to either alter the data structures or overwrite the SVG they generate.
- Our conclusion was that it would take more time and effort (in development and maintenance) to retrofit these charting libraries to our visualizations needs rather than simply doing it ourselves.

notes:
meks

---

## ✈️ 🌴 SVG Island 🌴 

---

### What is SVG? 🤔 
- **[SVG](https://developer.mozilla.org/en-US/docs/Web/SVG)**: Markup language for describing two-dimensional based vector graphics.
- **[Element](https://developer.mozilla.org/en-US/docs/Web/SVG/Element)**: Used to create drawings and images.
- **[Attribute](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute)**: Used to modify how an element should be handled or rendered.
- [An SVG Primer](https://www.w3.org/Graphics/SVG/IG/resources/svgprimer.html) for the curious.

notes:
meks

---

### Let's go over the basics 🧐 

---

### First we define a ViewBox
**[ViewBox](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/viewBox)**: Defines the position and dimension, in user space, of an SVG viewport.
```html
<svg viewBox="0 0 1174 429" xmlns="http://www.w3.org/2000/svg">
</svg>
```
![empty_viewBox](https://user-images.githubusercontent.com/5237832/218849904-91f3d1f1-6140-48b8-9d47-dc5f6b0a7182.png)

notes:
mark

---

### Outline the ViewBox
```html
<svg viewBox="0 0 1174 429" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="100%" height="100%" fill="none" stroke="black" stroke-width="4" />
</svg>
```
![viewbox_outline](https://user-images.githubusercontent.com/5237832/218851323-37e48f88-131c-4b25-9609-f6a333b43fb0.png)

notes:
mark
Use the `rect` element with 100% width, height to enable use to SEE the ViewBox

The IO.inspect of SVG

---

### Recall Geometry
<img src="https://user-images.githubusercontent.com/5237832/219403192-0deb8989-5b4a-4512-9a03-32e7639a224f.png" alt="cartesian coordinate system" style="height: 400px; width:400px;"/>

notes:
meks
Recall the Cartesian coordinate system from Geometry
The top right quadrant (positive x, positive y) is the applicable to SVG
Note the origin (0, 0) is in the bottom left corner of quadrant 1

---

### SVG Coordinate System 🙃
![svg_coordinate_system](https://user-images.githubusercontent.com/5237832/218846599-b12d28d7-7e40-4c89-b41e-29968878eb2f.png)

notes:
meks
The SVG coordinate system is similar to the Cartesian coordinate system (quadrant 1) expect the origin (0,0) is in the top left corner 

---

### Our bread and butter 🧈
**[Polyline](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/polyline)**: Creates straight lines connecting several points.

```
<polyline points="100,429 100,0" fill="none" stroke="black" />
```
![polyline](https://user-images.githubusercontent.com/5237832/218853849-c169972a-25b3-4846-b6b3-10e20ac21405.png)

notes:
mark

Explain how we will use polyline element

Consider removing fill and adding stroke-width with big fat line, different color other than black

---

### The other element
**[Text](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/text)**: draws a graphics element consisting of text.

```
<text x="200" y="200" font-size="20px">Hello SVG</text>
```
![text_element](https://user-images.githubusercontent.com/5237832/219486890-92cdf1d4-a4c7-4285-8a4b-b8cee66e14ec.png)

notes:
mark

Explain how we will use text element

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

![CleanShot 2023-08-02 at 18 00 19](https://github.com/gridpoint-com/svg_island/assets/60719697/21432ab7-09e6-4672-bb4d-e2da3316ef5d)

notes:
gif of drawing a line.

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

![CleanShot 2023-08-02 at 18 09 40](https://github.com/gridpoint-com/svg_island/assets/60719697/47b26db0-45d8-4b00-919d-031892b36853)

notes:
slow gif of drawing

Meks: Pick a point to start at the bottom of the M. Extend the line to the
height of the M with a slight slant to the right.
From the end of the previous line, draw a line downwards that's half the height
of the previous line.
From the end of the previous line, draw a line that rises half the height of
the letter M.
From the end of the previous line, draw a line downwards that's the height of
the letter M with a slight slant to the right.

---

### Draw an “M”

<img width="270" alt="CleanShot 2023-08-02 at 18 12 04@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/b0f1440d-1a15-421c-8e5d-0c5be68a44b6">

notes:
image of “M“
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

![CleanShot 2023-08-02 at 18 22 41](https://github.com/gridpoint-com/svg_island/assets/60719697/d8ca3ea0-5b9c-4145-80fb-3889a10b1d2e)

notes: slow gif drawing the line chart

Meks: Let’s start the first line down where the 18k is. Put your pen to the
paper at that point, and drag upward at a slight right angle and stop at around
64k. Starting where you ended the previous line, draw a new line upwards and
stop at 72k. Starting where you ended that line, draw another one down 64k. We
would keep repeating this process for all the points we want to mark on the
line chart.

---

### Draw a line chart

<img width="397" alt="CleanShot 2023-08-02 at 18 24 12@2x" src="https://github.com/gridpoint-com/svg_island/assets/60719697/4a95a64e-65be-4739-8db1-e6527eb44851">

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

  ```HTML
      <svg viewBox={"0 0 800 210}"} width="800" height="210" xmlns="http://www.w3.org/2000/svg" >
        <rect width="100%" height="100%" fill="none" stroke="black" />
        <polyline points="0,0 300,190" stroke="black" />
      </svg>
  ```

  ![CleanShot 2023-08-02 at 18 42 53@2x](https://github.com/gridpoint-com/svg_island/assets/60719697/28bfe951-10f5-4642-b57a-849a07e59b9b)

notes:

code snippet: a polyline with 2 points
image: that specific polyline
Meks: The crux is that we have two points, the start and the end of the line.
We connect those points to create a line. This is important for our use case
because we constraint the use of the polyline to only accept two points, ie two
sets of x and y coordinates. This means when we use polyline, we create two
points and connect them together with a straight line. In this example, the
polyline starts at 0,0 and ends at 300x and 190y. This was a conscious choice 
we made because then each line segment represents a piece of data that we can 
interact with.

---

### Important Point 2 

* Side effect of point 1, constraining polyline to 2 points
* Utilize last known location to keep drawing more lines

```HTML
      <svg viewBox={"0 0 800 210}"} width="800" height="210" xmlns="http://www.w3.org/2000/svg" >
        <rect width="100%" height="100%" fill="none" stroke="black" />
        <polyline points="0,0 300,190" stroke="black" />
        <polyline points="300,190 500,80" stroke="green" />
      </svg>
```

![CleanShot 2023-08-02 at 18 52 40@2x](https://github.com/gridpoint-com/svg_island/assets/60719697/6598e0fb-b2d2-410a-8809-a1df2fa0e3ba)

notes:
Mark: The second big take away of this exercise is that I use my last known
location to keep drawing more lines. The end of the previous line becomes the
start of the next line. Here, you can see that the coordinate of 300x and 190y
is both the end of the first line, and the start of the second line. This 
let’s us algorithmically calculate coordinates to draw lines based on the data
points in the the dataset that we want to represent.

---

### Jason Downloads

notes: Meks

image of official Jason Downloads chart

Most of us are probably familiar with Hex packages and have seen their download charts. We built a small demo app with the aim of replicating the Jason downloads chart. This demo is available publically. For anyone interested in seeing the code in it’s completed form, we’ll provide the link at the end.

---

### Jason Downloads

```Elixir
<%= for %{line_start: line_start, line_end: line_end} = line <- @chart.line_coordinates do %>
    <polyline
      points={"#{line_start.x},#{line_start.y} #{line_end.x},#{line_end.y}"}
      stroke="black"
    />
<% end %>
```

notes:

image of unstyled Jason Downloads demo

What you see here on the screen is a hand built SVG replica. Every part was built using either polylines, or text elements. We took the data from the original chart, ran it through a transformation to create a list of structs that has the x and y coordinates for each line segment. The keys to this transformation lie in using the previous line’s end coordinates as the start of the current line and then using the dataset and dimensions of the SVG viewport to scale and determine the coordinates of the end of the line.

---

### Jason Downloads

```HTML
<polyline
  points={"#{line_start.x},#{line_start.y} #{line_end.x},#{line_end.y}"}
  class={line.class}
/>
```

`class: "#{color} [stroke-width:3] [stroke-linecap:round]"`

notes:

image of styled Jason Downloads demo

Here is that same chart, but with Tailwind styling applied. For the colored lines we remove the stroke black attribute and replace it with Tailwind classes which we add to the Chart struct for each line segment. We adjust the line width, give it rounded edges, and change the color based of the percent of lines drawn to give it that color fade appearance.

---

### Jason Downloads

```HTML
<text x={label.x} y={label.y} class={label.class}>
  <%= label.value %>
</text>
```

```
 %{
   label: %{
   x: label_x,
   y: label_y,
   value: y_label_value,
   class: "fill-slate-400 text-xs [dominant-baseline:auto] [text-anchor:start]"
}
```

notes:

The text elements for the y labels and the chart legend are similarly styled with Tailwind. A really helpful CSS trick is to use dominant-baseline and text-anchor attributes to position the text element relative to the coordinate. This allows us a bit more granularity with positioning the element without having to use magic numbers and adjust the coordinates themselves.

---

### Jason Downloads


```Elixir
<polyline
  points={"#{line_start.x},#{line_start.y} #{line_end.x},#{line_end.y}"}
  class={line.class}
  phx-click={JS.push("show-tooltip", value: line)}
  phx-click-away="dismiss-tooltip"
/>
<.tooltip :if={@tooltip} x={@tooltip.x} y={@tooltip.y} value={@tooltip.value} />
```

notes:

gif of clicking on lines to show the tool tip

If you recall, we constrained our polylines to only have 2 points. What this allows us to do is interact with each line. We can add phx-click and click-away events to each polyline. The event handlers set the tooltip assigns and will display or hide the value from the dataset at the line’s end point.

---

### How did we come up with this approach?

* Bottom up approach
* Hand crafted an SVG to match design
* Abstracted chart elements piece by piece

![bar_chart_component](https://github.com/gridpoint-com/svg_island/assets/5237832/1847c210-6476-4edc-a4f4-40266d68cc45)

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

![bar_chart_tooltip](https://github.com/gridpoint-com/svg_island/assets/5237832/35192551-e3b7-478b-885b-adba98275dbf)

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

![cast_away_svg](https://github.com/gridpoint-com/svg_island/assets/5237832/7891fd00-aea4-4ce1-967d-bf4baea95a24)

