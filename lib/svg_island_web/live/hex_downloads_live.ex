defmodule SvgIslandWeb.HexDownloadsLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    chart_dimensions = %{
      viewbox_height: 210,
      viewbox_width: 800
    }

    socket =
      assign(socket,
        chart: %{
          chart_dimensions: chart_dimensions
        }
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Hex Downloads</h1>

    <svg
      viewBox={"0 0 #{@chart.chart_dimensions.viewbox_width} #{@chart.chart_dimensions.viewbox_height}"}
      width={"#{@chart.chart_dimensions.viewbox_width}"}
      height={"#{@chart.chart_dimensions.viewbox_height}"}
      xmlns="http://www.w3.org/2000/svg"
    >
    </svg>
    """
  end
end
