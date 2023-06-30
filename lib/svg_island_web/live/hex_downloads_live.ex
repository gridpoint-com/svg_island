defmodule SvgIslandWeb.HexDownloadsLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    dimensions = %{
      viewbox_height: 210,
      viewbox_width: 800,
      y_label_width: 70,
      header_height: 25,
      chart_height: 210,
      chart_width: 800
    }

    socket =
      assign(socket,
        chart: %{
          debug_mode: true,
          dimensions: dimensions
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
      </svg>
    </div>
    """
  end
end
