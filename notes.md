SVG Island Demo

1. Define our playground

%ChartDeminsions{
      viewbox_height: 500,
      viewbox_width: 1500
    }

<svg
          viewBox={"0 0 #{@chart_dimensions.viewbox_width} #{@chart_dimensions.viewbox_height}"}
          width={"#{@chart_dimensions.viewbox_width}"}
          height={"#{@chart_dimensions.viewbox_height}"}
          xmlns="http://www.w3.org/2000/svg"
        >

</svg>

At this point we have a working SVG yay!

Use debug mode and rects to view the pieces of the chart

<%= if @debug_graph do %>
            <rect width="100%" height="100%" fill="none" stroke="black" />

Now you see the viewbox

Next we will build out individual rectangles in debug mode to help determine our dimensions of the components of the chart

<rect
              x="0"
              y="0"
              width={@chart_dimensions.viewbox_width}
              height={@chart_dimensions.header_height}
              fill="none"
              stroke="red"
            />
            <rect
              x="0"
              y={@chart_dimensions.header_height}
              width={@chart_dimensions.y_label_width}
              height={@chart_dimensions.chart_height}
              fill="none"
              stroke="green"
            />
            <rect
              x={@chart_dimensions.y_label_width}
              y={@chart_dimensions.header_height}
              width={@chart_dimensions.chart_width - @chart_dimensions.y_label_width}
              height={@chart_dimensions.chart_height}
              fill="none"
              stroke="blue"
            />

%ChartDeminsions{
      header_height: 100,
      chart_height: 320,
      chart_width: 1500,
      y_label_width: 70,
    }

Now that we have defined the dimensions for the compoents of the chart we can start filling in the rectangles



Next we gather our data for the x axis is will a list of dates for this chart

Given this list of dates we can map over them and start to build out our structure used to actually display the data

This mapping builds our a list of maps that holds the raw value, a value transformed for presentation, and the style for that value

Enum.map(dates, fn %{date: date} ->
      label = Calendar.strftime(date, "%-m/%-d")

      %{
        value: label,
        label: label,
        label_class: chart_style_scheme.x_label_class
      }
    end)

%ChartStyleScheme{
      x_label_class:
        "text-xs fill-grey-500 stroke-white [stroke-width:10] [paint-order:stroke] [dominant-baseline:hanging] [text-anchor:middle]",
    }

At this point we have our x labels and we have styled them


Next will we generate the coordinates to draw the x labels on the SVG

Enum.reduce(x_labels, [], fn
      # This matches on the first point to be drawn, in order to consider the initial spacing from the labels
      x_label, [] ->
        [
          Map.put(x_label, :coordinates, %{
            x_min: chart_dimensions.y_label_width,
            y_min: chart_dimensions.header_height,
            x_max: chart_dimensions.y_label_width,
            y_max: chart_dimensions.viewbox_height
          })
        ]

      _do_nothing ->

end

<%= for x_label <- @meter_x_labels do %>
            <.draw_text
              x={x_label.coordinates.x_max}
              y={
                @chart_dimensions.header_height + @chart_dimensions.chart_height +
                  @chart_dimensions.x_label_padding
              }
              label={x_label.label}
              class={x_label.label_class}
            />
          <% end %>

Display that one point in the list was drawn

Now that we drawn one label we can step a specified distance for the remainer of the labels

%ChartDeminsions{
      x_label_distance: 42,
    }

Replace do nothing with stepping x label distance for each x label

# This matches for each additional point
      x_label, [prev_x_label | _] = coordinates ->
        [
          Map.put(x_label, :coordinates, %{
            x_min: prev_x_label.coordinates.x_min + chart_dimensions.x_label_distance,
            y_min: prev_x_label.coordinates.y_min,
            x_max: prev_x_label.coordinates.x_max + chart_dimensions.x_label_distance,
            y_max: prev_x_label.coordinates.y_max
          })
          | coordinates
        ]

Concepting you are now equiped with everything you need to build the rest of the chart

* At a high level this is the concpet for building a custom chart
Have a list of data
Apply style to each element of that data from a struct you defined
Then you generate a coordinate for each piece of data based on the dimensions struct you defined
Finally you iterate through the draw the SVGs onto the viewbox



end of session 1

We have drawn the x labels and we have understood the concept used to build the components of the chart



session 2 
we start building hex chart with the knowledge and we have a note any struggeles we have

can we make a svg_island? repo











7/26

How to draw a straight line?

Explain it like I'm 5 and haven't drawn a line before

Pretend I'm on pen and paper


Option 1

pick a point to start at

pick a point to stop at

connect the two points

this gives us a straight line


Option 2

pick a point to start at

drag pen horizontally across the paper

pick a point to stop at

this gives us a straight line








































How to draw the letter M?

Explain it like I'm 5 and I've only drawn a straight line before

Pretend I'm on pen and paper



we can construct the letter M with a series of straight line


Option 1

pick a point to start the top left part of the M

from point drag pen downwards for the height of the desired M

repeat the same process but add distance for width of M

pick a point in the center of the two lines we drew

from that point we CONNECTED that point to the stop of both of the previous lines


Option 2 (easy to follow where you at, you look at location of the previous point)

pick a point to start at the bottom of the M

extend the line to the height of the M giving it a slight slant

from the end of the previous line, draw a line downwards that's half the height of the previous line

from the end of the previous line, draw a line that rises half the height of the letter M

from the end of the previous line, draw a line downwards that's the height of the letter M


How to draw a line chart? Using Option 2 from previous prompt

Explain it like I'm 5 and I've only drawn an M before

Pretend I'm on pen and paper




* special case for first line
start drawing a line at 18k

stop drawing a line at 64k

give line a slight angle

* repeat this process for the remaining lines
start the next line where the previous line ended

stop drawing the line at 72k

* repeat
start the next line where the previous line ended

stop drawing the line at 64k




ELI5

pick a point to start drawing a line 

stop drawing the line when it makes sense

start drawing the next line where the previou line eneded

stop drawing the line when it makes sense

start drawing the next line where the previous line eneded

continue ....


when does it make sense?


we draw the line based on the the underlying dataset

....

pick the point that represents our first datapoint, 18k

stop drawing the line at the next datapoint, 64k

start drawing the line from the current datapoint, 64k

stop drawing the line at the next datapoint, 72k

repeat for the entire dataset



POINT 1!

the crux of what were doing here is we have two points

(or the start of the line and end of the line)

we connect those two points to create a line


why point 1 is important!!???!!

we constraint our use of polyline to only accept two points

this means when we use polyline we create two points then connect them together to create a straight line

we chose to do this because then each line segment represents a piece of data we can interact with


POINT 2! (side effect of POINT 1)

I use my last known location to keep drawing more lines

The end of the previous line becomes the start of the next line

we use the location of the previous line to know where to start

then draw the line until to the point that presents the data point in our dataset










# Outline of back half of presentation



Starting at Let's build a line chart


meks
### draw a straight line

### draw an M

### draw a line chart

### bring up our two main points

show a complete line chart of jason downloads

talk about the chart struct and how we put all the pieces together


basics of svgs (we have this)

building chart using only two svg elements (polyline, text)

style with tailwind (chart structure, applying style to the elements)

click events on elements (how we add click events)

transition presentation from concepts to reality
talk about bar chart component and what we would do differently
talk about how we haven't figured out the perfect component
use chart as phoenix componet ()


then we need a live line chart and we figured out we could use
liveview streams to append to the chart
show a diff of how much work it took to switch a static chart to a live chart
append to chart with phoenix streams









Presentation built with obsidian + https://github.com/MSzturc/obsidian-advanced-slides
https://obsidian.md/

Chart component: https://github.com/gridpoint-com/phoenix/blob/main/lib/gridpoint_web/components/charts.ex
