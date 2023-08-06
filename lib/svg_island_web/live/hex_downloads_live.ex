defmodule SvgIsland.Chart do
  defstruct debug_mode: false, dimensions: %{}, dataset: [], y_label_values: []
end

defmodule SvgIslandWeb.HexDownloadsLive do
  use Phoenix.LiveView

  alias SvgIsland.Chart
  alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    dimensions = %{
      viewbox_height: 210,
      viewbox_width: 800,
      y_label_width: 70,
      header_height: 25,
      footer_height: 25,
      chart_height: 160,
      chart_width: 800
    }

    downloads = jason_downloads()

    chart =
      %Chart{}
      |> Map.put(:dimensions, dimensions)
      |> Map.put(:dataset, downloads)
      |> Map.put(:y_label_values, y_label_values(downloads))
      |> put_chart_line_coordinates()
      |> put_y_label_coordinates()

    socket =
      socket
      |> assign(:chart, chart)
      |> assign(:tooltip, nil)

    {:ok, socket}
  end

  def handle_event("show-tooltip", params, socket) do
    tooltip = %{
      x: params["x"],
      y: params["y"],
      value: params["value"]
    }

    {:noreply, assign(socket, :tooltip, tooltip)}
  end

  def handle_event("dismiss-tooltip", _params, socket) do
    {:noreply, assign(socket, :tooltip, nil)}
  end

  def handle_event(_, _params, socket) do
    {:noreply, socket}
  end

  defp put_chart_line_coordinates(%Chart{dataset: _dataset, dimensions: _dimensions} = chart) do
    line_coordinates =
      chart.dataset
      # |> Enum.take(1)
      |> Enum.reduce([], &calculate_line_coordinate(&1, &2, chart))

    Map.put(chart, :line_coordinates, line_coordinates)
  end

  # draw the first line as a point as we only have one data point
  defp calculate_line_coordinate(number_of_downloads, [], %Chart{} = chart) do
    first_line_start_x = 0
    first_line_start_y = scale_y_line_value(number_of_downloads, chart)
    first_line_end_x = 0
    first_line_end_y = scale_y_line_value(number_of_downloads, chart)

    [
      %{
        line_start: %{
          x: first_line_start_x,
          y: first_line_start_y
        },
        line_end: %{
          x: first_line_end_x,
          y: first_line_end_y
        },
        value: number_of_downloads,
        class: "stroke-indigo-700 [stroke-width:3] [stroke-linecap:round] hover:cursor-pointer"
      }
    ]
  end

  # draw the remaining lines of the chart
  defp calculate_line_coordinate(
         number_of_downloads,
         [previous_line | _] = line_coordinates,
         %Chart{} = chart
       ) do
    current_line_start_x = previous_line.line_end.x
    current_line_start_y = previous_line.line_end.y

    current_line_end_x = scale_x_line_value(previous_line, chart)
    current_line_end_y = scale_y_line_value(number_of_downloads, chart)

    percent_of_lines_drawn = Enum.count(line_coordinates) / Enum.count(chart.dataset)

    color = calulate_line_color(percent_of_lines_drawn)

    [
      %{
        line_start: %{
          x: current_line_start_x,
          y: current_line_start_y
        },
        line_end: %{
          x: current_line_end_x,
          y: current_line_end_y
        },
        value: number_of_downloads,
        class: "#{color} [stroke-width:3] [stroke-linecap:round] hover:cursor-pointer"
      }
      | line_coordinates
    ]
  end

  defp scale_x_line_value(previous_line, %Chart{dataset: dataset, dimensions: dimensions}) do
    number_of_datapoints = Enum.count(dataset)
    line_width = dimensions.chart_width / number_of_datapoints
    previous_line.line_end.x + line_width
  end

  defp scale_y_line_value(value, %Chart{dataset: dataset, dimensions: dimensions}) do
    chart_max = dimensions.header_height
    chart_min = dimensions.header_height + dimensions.chart_height
    chart_range = chart_min - chart_max

    value_scale = value / Enum.max(dataset)
    chart_scale = value_scale * chart_range
    chart_max + (chart_range - chart_scale)
  end

  defp calulate_line_color(percent_of_lines_drawn) do
    cond do
      percent_of_lines_drawn < 0.2 -> "stroke-indigo-600"
      percent_of_lines_drawn >= 0.2 && percent_of_lines_drawn < 0.4 -> "stroke-violet-600"
      percent_of_lines_drawn >= 0.4 && percent_of_lines_drawn < 0.6 -> "stroke-purple-600"
      percent_of_lines_drawn >= 0.6 && percent_of_lines_drawn < 0.8 -> "stroke-fuchsia-600"
      true -> "stroke-pink-600"
    end
  end

  defp put_y_label_coordinates(
         %Chart{y_label_values: _y_label_values, dimensions: _dimensions} = chart
       ) do
    y_label_coordinates =
      chart.y_label_values
      # |> Enum.take(2)
      |> Enum.reduce([], &calculate_y_label_coordinate(&1, &2, chart))

    Map.put(chart, :y_label_coordinates, y_label_coordinates)
  end

  # draw the very first label of the chart
  defp calculate_y_label_coordinate(y_label_value, [], %Chart{
         dimensions: dimensions
       }) do
    label_x = 0
    label_y = dimensions.header_height

    background_line_start_x = label_x
    background_line_start_y = label_y

    background_line_end_x = dimensions.chart_width
    background_line_end_y = label_y

    [
      %{
        label: %{
          x: label_x,
          y: label_y,
          value: y_label_value,
          class: "fill-slate-400 text-xs [dominant-baseline:auto] [text-anchor:start]"
        },
        background_line: %{
          line_start: %{
            x: background_line_start_x,
            y: background_line_start_y
          },
          line_end: %{
            x: background_line_end_x,
            y: background_line_end_y
          },
          class: "stroke-slate-300 [stroke-width:1]"
        }
      }
    ]
  end

  # draw the remaining labels for the chart
  defp calculate_y_label_coordinate(y_label_value, [previous_label | _] = y_labels, %Chart{
         y_label_values: y_label_values,
         dimensions: dimensions
       }) do
    step = (dimensions.header_height + dimensions.chart_height + 6) / Enum.count(y_label_values)

    label_x = 0
    label_y = previous_label.label.y + step

    background_line_start_x = label_x
    background_line_start_y = label_y

    background_line_end_x = dimensions.chart_width
    background_line_end_y = label_y

    [
      %{
        label: %{
          x: label_x,
          y: label_y,
          value: y_label_value,
          class: "fill-slate-400 text-xs [dominant-baseline:auto] [text-anchor:start]"
        },
        background_line: %{
          line_start: %{
            x: background_line_start_x,
            y: background_line_start_y
          },
          line_end: %{
            x: background_line_end_x,
            y: background_line_end_y
          },
          class: "stroke-slate-300 [stroke-width:1]"
        }
      }
      | y_labels
    ]
  end

  def render(assigns) do
    ~H"""
    <div class="m-16">
      <h1 class="text-xl font-bold text-slate-900">Downloads</h1>

      <svg
        viewBox={"0 0 #{@chart.dimensions.viewbox_width} #{@chart.dimensions.viewbox_height}"}
        width={"#{@chart.dimensions.viewbox_width}"}
        height={"#{@chart.dimensions.viewbox_height}"}
        xmlns="http://www.w3.org/2000/svg"
      >
        <!-- start debug mode, use rectangles to outline the elements of your chart -->
        <rect :if={@chart.debug_mode} width="100%" height="100%" fill="none" stroke="black" />
        <rect
          :if={@chart.debug_mode}
          x="0"
          y="0"
          width={@chart.dimensions.chart_width}
          height={@chart.dimensions.header_height}
          fill="none"
          stroke="red"
        />
        <rect
          :if={@chart.debug_mode}
          x="0"
          y={@chart.dimensions.header_height}
          width={@chart.dimensions.chart_width}
          height={@chart.dimensions.chart_height}
          fill="none"
          stroke="green"
        />
        <rect
          :if={@chart.debug_mode}
          x="0"
          y={@chart.dimensions.header_height + @chart.dimensions.chart_height}
          width={@chart.dimensions.chart_width}
          height={
            @chart.dimensions.header_height + @chart.dimensions.chart_height +
              @chart.dimensions.footer_height
          }
          fill="none"
          stroke="blue"
        />
        <!-- end debug mode -->
        <.chart_legend value="Last 30 days, all versions" x={@chart.dimensions.chart_width} y={0} />
        <%= for %{label: label, background_line: background_line} <- @chart.y_label_coordinates do %>
          <text x={label.x} y={label.y} class={label.class}>
            <%= label.value %>
          </text>
          <.draw_monoline
            line_start_x={background_line.line_start.x}
            line_start_y={background_line.line_start.y}
            line_end_x={background_line.line_end.x}
            line_end_y={background_line.line_end.y}
            class={background_line.class}
          />
        <% end %>
        <%= for %{line_start: line_start, line_end: line_end} = line <- @chart.line_coordinates do %>
          <.draw_monoline
            line_start_x={line_start.x}
            line_start_y={line_start.y}
            line_end_x={line_end.x}
            line_end_y={line_end.y}
            class={line.class}
            on_click_event_name="show-tooltip"
            on_click_event_params={%{value: line.value}}
          />
          <.tooltip :if={@tooltip} x={@tooltip.x} y={@tooltip.y} value={@tooltip.value} />
        <% end %>
      </svg>
    </div>
    """
  end

  defp jason_downloads() do
    [
      17_000,
      71_000,
      64_000,
      63_000,
      55_000,
      18_000
    ] ++
      [
        16_000,
        52_000,
        48_000,
        60_000,
        62_000,
        66_000,
        18_000
      ] ++
      [
        16_000,
        84_000,
        71_000,
        66_000,
        56_000,
        17_000
      ] ++
      [
        16_000,
        75_000,
        70_000,
        71_000,
        74_000,
        60_000,
        16_000
      ] ++
      [
        16_000,
        72_000,
        74_000
      ]
  end

  defp y_label_values(dataset, steps \\ 5) do
    max_data_point = Enum.max(dataset)
    step_by = trunc(max_data_point / steps)

    Enum.to_list(max_data_point..0//-step_by)
  end

  attr :class, :string,
    default: "fill-slate-500 text-sm font-semibold [dominant-baseline:hanging] [text-anchor:end]"

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :value, :string, required: true

  defp chart_legend(assigns) do
    ~H"""
    <text x={@x} y={@y} class={@class}><%= @value %></text>
    """
  end

  attr :line_start_x, :integer, required: true
  attr :line_start_y, :integer, required: true
  attr :line_end_x, :integer, required: true
  attr :line_end_y, :integer, required: true
  attr :class, :string, required: true
  attr :on_click_event_name, :string, default: ""
  attr :on_click_event_params, :map, default: %{}

  defp draw_monoline(assigns) do
    ~H"""
    <polyline
      points={"#{@line_start_x},#{@line_start_y} #{@line_end_x},#{@line_end_y}"}
      class={@class}
      phx-click={
        JS.push(@on_click_event_name,
          value: Map.merge(@on_click_event_params, %{x: @line_end_x, y: @line_end_y})
        )
      }
      phx-click-away="dismiss-tooltip"
    />
    """
  end

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :value, :string, required: true
  attr :text_class, :string, default: "fill-zinc-600 text-sm font-semibold"
  attr :x_offset, :integer, default: 6
  attr :y_offset, :integer, default: 15
  attr :rect_class, :string, default: "fill-slate-100"
  attr :rx, :integer, default: 5
  attr :width, :string, default: "60px"
  attr :height, :string, default: "20px"

  defp tooltip(assigns) do
    ~H"""
    <rect
      x={@x - @x_offset}
      y={@y - @y_offset}
      width={@width}
      height={@height}
      rx={@rx}
      class={@rect_class}
    />
    <text x={@x} y={@y} class={@text_class}><%= @value %></text>
    """
  end
end
