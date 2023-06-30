defmodule SvgIslandWeb.HexDownloadsLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    dimensions = %{
      viewbox_height: 210,
      viewbox_width: 800
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
    <h1>Hex Downloads</h1>

    <svg
      viewBox={"0 0 #{@chart.dimensions.viewbox_width} #{@chart.dimensions.viewbox_height}"}
      width={"#{@chart.dimensions.viewbox_width}"}
      height={"#{@chart.dimensions.viewbox_height}"}
      xmlns="http://www.w3.org/2000/svg"
    >
      <!-- start debug mode, use rectangles to outline the elements of your chart -->
      <rect :if={@chart.debug_mode} width="100%" height="100%" fill="none" stroke="black" />
      <!-- end debug mode -->
    </svg>
    """
  end
end
