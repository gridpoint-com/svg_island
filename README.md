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

### How did come up with this approach?

* Bottom up approach
* Hand crafted an SVG to match design
* Abstracted chart piece by piece

![bar chart component](link to image)

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
* Access to coordinates
* Elements of the chart drawn independently

![bar chart tooltip](link to image)

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

### Would we recommended doing this?

* Learning SVG isn't too bad
* We didn't introduce a JS dependency
* Great power, great responibility

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

![cast away svg](link to image)
