defmodule SyobonWeb.GameLive do
  use SyobonWeb, :live_view

  @width 540
  @height 540

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, me: %{x: 320, y: 320}, width: @width, height: @height)}
  end

  @impl true
  def handle_event("move", %{"key" => key}, socket = %{assigns: %{me: me = %{x: x, y: y}}}) do
    case key do
      "w" -> {:noreply, assign(socket, me: %{me | y: max(0, y - 10)})}
      "a" -> {:noreply, assign(socket, me: %{me | x: max(0, x - 10)})}
      "s" -> {:noreply, assign(socket, me: %{me | y: min(@height - 1, y + 10)})}
      "d" -> {:noreply, assign(socket, me: %{me | x: min(@width - 1, x + 10)})}
    end
  end
end
