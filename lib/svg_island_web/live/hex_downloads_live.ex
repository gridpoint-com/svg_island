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
      chart_height: 210,
      chart_width: 800
    }

    downloads = jason_downloads()

    chart =
      %Chart{}
      |> Map.put(:dimensions, dimensions)
      |> Map.put(:dataset, downloads)
      |> Map.put(:y_label_values, y_label_values())
      |> put_chart_line_coordinates()
      |> put_y_label_coordinates()

    socket =
      socket
      |> assign(:chart, chart)
      |> assign(:tooltip, nil)

    {:ok, socket}
  end

  def handle_event("show-tooltip", params, socket) do
    x_coor = (params["line_start"]["x"] + params["line_end"]["x"]) / 2
    y_coor = (params["line_start"]["y"] + params["line_end"]["y"]) / 2

    tooltip = %{
      x: x_coor,
      y: y_coor,
      value: params["value"]
    }

    {:noreply, assign(socket, :tooltip, tooltip)}
  end

  def handle_event("dismiss-tooltip", _params, socket) do
    {:noreply, assign(socket, :tooltip, nil)}
  end

  defp put_chart_line_coordinates(%Chart{dataset: _dataset, dimensions: _dimensions} = chart) do
    line_coordinates =
      chart.dataset
      # |> Enum.take(1)
      |> Enum.reduce([], &calculate_line_coordinate(&1, &2, chart))

    Map.put(chart, :line_coordinates, line_coordinates)
  end

  # draw the very first line of the chart
  defp calculate_line_coordinate(number_of_downloads, [], %Chart{
         dataset: all_downloads,
         dimensions: dimensions
       }) do
    # scale x value
    number_of_datapoints = Enum.count(all_downloads)
    line_width = dimensions.chart_width / number_of_datapoints

    # scale y value
    percent_of_total_downloads = number_of_downloads / Enum.max(all_downloads)
    line_length = percent_of_total_downloads * dimensions.chart_height

    first_line_start_x = 0
    first_line_start_y = dimensions.chart_height

    first_line_end_x = line_width
    first_line_end_y = line_length

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
         %Chart{dataset: downloads, dimensions: dimensions}
       ) do
    # scale x value
    number_of_datapoints = Enum.count(downloads)
    line_width = dimensions.chart_width / number_of_datapoints

    # scale y value
    percent_of_total_downloads = number_of_downloads / Enum.max(downloads)
    line_length = percent_of_total_downloads * dimensions.chart_height

    current_line_start_x = previous_line.line_end.x
    current_line_start_y = previous_line.line_end.y

    current_line_end_x = current_line_start_x + line_width
    current_line_end_y = dimensions.chart_height - line_length

    percent_of_lines_drawn = Enum.count(line_coordinates) / Enum.count(downloads)

    color =
      cond do
        percent_of_lines_drawn < 0.2 -> "stroke-indigo-600"
        percent_of_lines_drawn >= 0.2 && percent_of_lines_drawn < 0.4 -> "stroke-violet-600"
        percent_of_lines_drawn >= 0.4 && percent_of_lines_drawn < 0.6 -> "stroke-purple-600"
        percent_of_lines_drawn >= 0.6 && percent_of_lines_drawn < 0.8 -> "stroke-fuchsia-600"
        true -> "stroke-pink-600"
      end

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

  defp put_y_label_coordinates(
         %Chart{y_label_values: _y_label_values, dimensions: _dimensions} = chart
       ) do
    y_label_coordinates =
      chart.y_label_values
      # |> Enum.take(1)
      |> Enum.reduce([], &calculate_y_label_coordinate(&1, &2, chart))

    Map.put(chart, :y_label_coordinates, y_label_coordinates)
  end

  defp calculate_y_label_coordinate(y_label_value, [], %Chart{
         y_label_values: y_label_values,
         dimensions: dimensions
       }) do
    step = dimensions.chart_height / Enum.count(y_label_values)

    [
      %{
        x: 0,
        y: step,
        value: y_label_value,
        class: "fill-slate-400 text-xs [dominant-baseline:auto] [text-anchor:start]"
      }
    ]
  end

  defp calculate_y_label_coordinate(y_label_value, [previous_label | _] = y_labels, %Chart{
         y_label_values: y_label_values,
         dimensions: dimensions
       }) do
    step = dimensions.chart_height / Enum.count(y_label_values)
    y = previous_label.y + step

    [
      %{
        x: 0,
        y: y,
        value: y_label_value,
        class: "fill-slate-400 text-xs [dominant-baseline:auto] [text-anchor:start]"
      }
      | y_labels
    ]
  end

  def render(assigns) do
    ~H"""
    <div class="m-16">
      <h1>Hex Downloads</h1>

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
          width={@chart.dimensions.y_label_width}
          height={@chart.dimensions.viewbox_height}
          fill="none"
          stroke="blue"
        />
        <rect
          :if={@chart.debug_mode}
          x="0"
          y="0"
          width={@chart.dimensions.viewbox_width}
          height={@chart.dimensions.header_height}
          fill="none"
          stroke="red"
        />
        <rect
          :if={@chart.debug_mode}
          x="0"
          y="0"
          width={@chart.dimensions.chart_width}
          height={@chart.dimensions.chart_height}
          fill="none"
          stroke="green"
        />
        <!-- end debug mode -->
        <%= for %{x: x, y: y} = label <- @chart.y_label_coordinates do %>
          <text x={x} y={y} class={label.class}>
            <%= label.value %>
          </text>
        <% end %>
        <%= for %{line_start: line_start, line_end: line_end} = line <- @chart.line_coordinates do %>
          <polyline
            points={"#{line_start.x},#{line_start.y} #{line_end.x},#{line_end.y}"}
            fill="none"
            stroke="black"
            class={line.class}
            phx-click={JS.push("show-tooltip", value: line)}
            phx-click-away="dismiss-tooltip"
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

  defp y_label_values() do
    [72_000, 54_000, 36_000, 18_000, 0]
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
    <text x={@x} y={@y} class={@text_class}>
      <%= @value %>
    </text>
    """
  end
end
