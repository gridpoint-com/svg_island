defmodule SvgIsland.Chart do
  defstruct debug_mode: false, dimensions: %{}, dataset: []
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
      |> put_chart_line_coordinates()

    socket =
      socket
      |> assign(:chart, chart)
      |> assign(:tooltip, nil)

    {:ok, socket}
  end

  def handle_event("show-tooltip", params, socket) do
    tooltip = %{
      x: params["line_end"]["x"],
      y: params["line_end"]["y"],
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
        value: number_of_downloads
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
        value: number_of_downloads
      }
      | line_coordinates
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
        <%= for %{line_start: line_start, line_end: line_end} = line_coordinate <- @chart.line_coordinates do %>
          <polyline
            points={"#{line_start.x},#{line_start.y} #{line_end.x},#{line_end.y}"}
            fill="none"
            stroke="black"
            phx-click={JS.push("show-tooltip", value: line_coordinate)}
            phx-click-away="dismiss-tooltip"
          />
        <% end %>
        <text :if={@tooltip} x={@tooltip.x} y={@tooltip.y}>
          <%= @tooltip.value %>
        </text>
      </svg>
    </div>
    """
  end

  defp jason_downloads() do
    [
      18_000,
      63_000,
      72_000,
      71_000,
      66_000,
      60_000,
      18_000,
      18_000,
      54_000,
      72_000,
      71_000,
      70_000,
      55_000,
      18_000,
      18_000,
      69_000,
      71_000,
      66_000,
      60_000,
      54_000,
      18_000,
      18_000,
      52_000,
      45_000,
      55_000,
      59_000,
      62_000,
      18_000,
      18_000,
      75_000,
      73_000
    ]
  end
end
