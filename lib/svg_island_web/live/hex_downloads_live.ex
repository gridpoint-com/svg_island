defmodule SvgIslandWeb.HexDownloadsLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    style = %{
      y_label_class: "fill-grey-500 stroke-black text-xs [stroke-width:1]"
    }

    dimensions = %{
      viewbox_height: 210,
      viewbox_width: 800,
      y_label_width: 0,
      y_label_distance: 45,
      header_height: 25,
      chart_height: 210,
      chart_width: 800
    }

    y_labels =
      range_of_downloads()
      |> Enum.map(fn step ->
        %{value: step, label: step, y_label_class: style.y_label_class}
      end)
      |> calculate_y_label_coordinates(dimensions)
      |> dbg()

    socket =
      assign(socket,
        chart: %{
          debug_mode: true,
          dimensions: dimensions,
          y_labels: y_labels,
          style: style
        }
      )

    {:ok, socket}
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
          width={45}
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
        <%= for y_label <- @chart.y_labels do %>
          <.draw_text
            x={y_label.coordinates.x_min}
            y={y_label.coordinates.y_min}
            label={y_label.label}
            class={@chart.style.y_label_class}
          />
        <% end %>
      </svg>
    </div>
    """
  end

  defp range_of_downloads() do
    0..64000//16000
    |> Enum.to_list()
    |> Enum.reverse()
  end

  # defp y_label_coordinates(y_labels) do
  #   # Enum.reduce(y_labels, [] fn step, acc ->
  #   #   # text elements are just like rectangles in how they are drawn
  #   #
  #   # end) 
  # end
  defp calculate_y_label_coordinates(y_labels, chart_dimensions) do
    Enum.reduce(y_labels, [], fn
      y_label, [] ->
        [
          Map.put(y_label, :coordinates, %{
            x_min: chart_dimensions.y_label_width,
            y_min: 25,
            x_max: chart_dimensions.chart_width,
            y_max: chart_dimensions.header_height
          })
        ]

      y_label, [prev_y_label | _] = coordinates ->
        [
          Map.put(y_label, :coordinates, %{
            x_min: prev_y_label.coordinates.x_min,
            y_min: prev_y_label.coordinates.y_min + chart_dimensions.y_label_distance,
            x_max: prev_y_label.coordinates.x_max,
            y_max: prev_y_label.coordinates.y_max + chart_dimensions.y_label_distance
          })
          | coordinates
        ]
    end)
  end

  def draw_text(assigns) do
    ~H"""
    <text x={"#{@x}"} y={"#{@y}"} class={@class}><%= @label %></text>
    """
  end
end
