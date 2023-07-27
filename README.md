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
### Let's build a bar chart 🏗️ 

---

### Our first function component

```elixir
  def draw_polyline(assigns) do
    ~H"""
    <polyline
      points={"#{@x_min},#{@y_min} #{@x_max},#{@y_max}"}
      class={@class}
    />
    """
  end
```

```elixir
  def draw_polyline(%{on_click_event_name: event} = assigns) do
    ~H"""
    <polyline
      phx-click={JS.push(@on_click_event_name, value: "stuff")}
      points={"#{@x_min},#{@y_min} #{@x_max},#{@y_max}"}
      class={@class}
    />
    """
  end
```

notes:
meks
consider replacing these with screenshots

---

### Drawing the chart background: The Vertical Lines

<img width="1144" alt="image" src="https://user-images.githubusercontent.com/60719697/219527685-73e6a245-7019-4898-ac47-0e1a2e5e18f9.png">

```elixir
{{81, 0}, {81, 371}}
{{1174, 0}, {1174, 371}}
```

notes:
meks

---

### But how did we get here?
```elixir
  vertical_line_coordinates(
    {0, 0}, 
    {@viewbox_width, @viewbox_height}, 
    @viewbox_width) 
```

```elixir
  defp vertical_line_coordinates(
    {x_min, y_min}, {x_max, y_max}, step) do
    
    for x <- x_min..x_max//step do
      {{x, y_min}, {x, y_max}}
    end
  end
```

notes:
meks

---

### Drawing the chart background: The Horizontal Lines

<img width="1157" alt="Screenshot 2023-02-07 at 10 58 51 AM" src="https://user-images.githubusercontent.com/60719697/217312205-7cb576e6-d738-4af4-82dc-da59a1fc3e7e.png" style="display:inline-block;height: 400px; width:600px;">

```elixir
{{81, 0}, {1174, 0}}
{{81, 53}, {1174, 53}}
{{81, 106}, {1174, 106}}
{{81, 159}, {1174, 159}}
{{81, 212}, {1174, 212}}
{{81, 265}, {1174, 265}}
{{81, 318}, {1174, 318}}
{{81, 371}, {1174, 371}}
```

notes:
meks

---

### But how did we get here?
```elixir
  horizontal_line_coordinates(
	{0, 0}, 
	{@viewbox_width, @viewbox_height}, 
	@background_line_step_interval)

```

```elixir
  defp horizontal_line_coordinates(
    {x_min, y_min}, {x_max, y_max}, step) do
    
    for y <- y_min..y_max//step do
      {{x_min, y}, {x_max, y}}
    end
  end
```

notes:
meks

---

### Bar Chart Background Complete!

<img width="1137" alt="image" src="https://user-images.githubusercontent.com/60719697/217317622-14e4d9bf-e02f-4126-a9eb-32b80c6a4cfc.png">

notes:
meks

---

![success_kid](https://user-images.githubusercontent.com/5237832/218855240-832a8182-b91a-4053-b400-674466f375b3.jpeg)

---

### Our second (and last) function component
```elixir
  def draw_text(assigns) do
    ~H"""
    <text x={"#{@x}"} y={"#{@y}"} class={@class}><%= @label %></text>
    """
  end
```

```elixir
  def draw_text(%{on_click_event_name: event} = assigns) do
    ~H"""
    <text
      phx-click={JS.push(@on_click_event_name, value: "stuff")}
      x={"#{@x}"}
      y={"#{@y}"}
      class={@class}
    >
      <%= @label %>
    </text>
    """
  end
```

notes:
mark

---

### Draw X Axis Labels

<img width="1140" alt="image" src="https://user-images.githubusercontent.com/60719697/217319374-a8767479-150f-4838-a0c4-7d04dfc42333.png">

```elixir
[
  {{118, 406.5}, "Jan", "text-xs font-normal leading-4 fill-grey-1000"},
  {{208, 406.5}, "Feb", "text-xs font-normal leading-4 fill-grey-1000"},
  ...
  {{478, 406.5}, "May", "text-xs font-normal leading-4 fill-grey-400"},
  ...
]
```

notes:
mark

---

### Wait...how did you do that?

```elixir
horizontal_label_coordinates(
  {@y_label_width, 0}, 
  {@chart_width, @chart_height}, 
  @x_label_left_margin, 
  @x_label_bottom_margin, 
  @x_step_between_labels, 
  @chart_data) 
```

```elixir
  defp horizontal_label_coordinates(
         {x_min, _y_min},
         {_x_max, y_max},
         x_label_left_margin,
         x_label_bottom_margin,
         x_step_between_labels,
         data
       ) do
    origin = {x_min + x_label_left_margin, y_max - x_label_bottom_margin / 2}

    data
    |> Enum.reduce([], fn
      %{"x_label" => label, "x_label_class" => class}, [] ->
        [{origin, label, class}]

      %{"x_label" => label, "x_label_class" => class},
      [{{x, y}, _label, _class} | _] = coordinates ->
        [{{x + x_step_between_labels, y}, label, class} | coordinates]
    end)
    |> Enum.reverse()
  end
```

notes:
mark

---

### Draw Y Axis Labels

<img width="1209" alt="image" src="https://user-images.githubusercontent.com/60719697/219532482-98438352-f9fb-4b0a-b289-0cb13f86b9f8.png">

```elixir
[ 
  {{40, 57}, "$3,000", "text-xs font-normal leading-4 fill-grey-1000 [text-anchor:middle]"},
  {{40, 110}, "$2,500", "text-xs font-normal leading-4 fill-grey-1000 [text-anchor:middle]"},
  ...
  {{40, 322}, "$500", "text-xs font-normal leading-4 fill-grey-1000 [text-anchor:middle]"},
  {{40, 375}, "$0", "text-xs font-normal leading-4 fill-grey-1000 [text-anchor:start]"}
]
```
notes: 
mark
meks: [text-anchor attribute](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/text-anchor)

---

### Now how did you do that one?

```elixir
vertical_label_coordinates(
  {@y_label_left_margin, @y_label_top_margin}, 
  {@chart_width, @chart_height}, 
  @y_step_between_labels, 
  @chart_y_labels)
```

```elixir
  defp vertical_label_coordinates(
         {x_min, y_min},
         {_x_max, _y_max},
         y_step_between_labels,
         y_labels
       ) do

    y_labels
    |> Enum.reduce([], fn
      %{"y_label" => label, "y_label_class" => class}, [] ->
        [{{x_min, y_min}, label, class}]

      %{"y_label" => label, "y_label_class" => class},
      [{{x, y}, _label, _class} | _] = coordinates ->
        [{{x, y + y_step_between_labels}, label, class} | coordinates]
    end)
    |> Enum.reverse()
  end
```

notes:
mark

---
### Bar Chart Labels Complete!
<img width="1225" alt="Screenshot 2023-02-07 at 11 34 39 AM" src="https://user-images.githubusercontent.com/60719697/217321102-a782b5d7-9702-44fd-b8f1-8a761d583415.png">

notes:
mark

---

![success_kid](https://user-images.githubusercontent.com/5237832/218855240-832a8182-b91a-4053-b400-674466f375b3.jpeg)

---

### Input to Draw a Bar Line
```elixir
%{
  "x_label" => "Jan",
  "x_label_class" => "text-xs font-normal leading-4 fill-grey-1000",
  "y_series" => [%{
    "y" => 195, "class" => "stroke-grey-800 stroke-[4]"
  }]
},
%{
  "x_label" => "Feb",
  "x_label_class" => "text-xs font-normal leading-4 fill-grey-400",
  "y_series" => []
}
```
<img alt="image" src="https://user-images.githubusercontent.com/60719697/217330109-d010d8ff-f5fb-4aac-a8ff-361e663c9642.png" style="width:600px;height:250px">
notes:
meks
Show picture of bar line without any classes

---

### Once more, with style

```elixir
%{
  "x_label" => "Jan",
  "x_label_class" => "text-xs font-normal leading-4 fill-grey-1000",
  "y_series" => [%{
    "y" => 195,
	"class" => "stroke-vibrant-blue-400 stroke-[4] [stroke-linecap:round]"
  }]
}
```
<img alt="Screenshot 2023-02-07 at 12 24 23 PM" src="https://user-images.githubusercontent.com/60719697/217332761-87e0e345-12dc-419e-8def-cdd5b8d66ad8.png" style="width:800px;height:400px">

notes:
meks
Show picture of bar line with list of tailwind classes applied

---

### Hey look, a bar chart :sunglasses:
<img width="1188" alt="Screenshot 2023-02-07 at 12 26 26 PM" src="https://user-images.githubusercontent.com/60719697/217333368-7f2eaeef-a3be-4cc6-a2f2-4730c2cade51.png">
notes:
mark

---

### Summary of Features
- Stateless Phoenix component
- Uses only two SVG elements (polyline, text)
- Coordinate generation and element drawing are "decoupled"
- Each element can be styled individually
- All styling via tailwind classes, no direct use of SVG attributes
- Each element can have a click event
- Chart can be redrawn by simply updating the assigns

notes:
mark

---

### Thanks for attending

Find the slides in GitHub discussions:
https://github.com/gridpoint-com/phoenix/discussions/863

<img width="600" alt="Screenshot 2023-02-07 at 12 24 23 PM" src="https://user-images.githubusercontent.com/5237832/218856202-453fe42c-1472-40df-93a6-3aba6b3616c2.png">

notes:
meks
