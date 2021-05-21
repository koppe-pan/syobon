defmodule SyobonWeb.GameLive do
  use SyobonWeb, :live_view

  @width 540
  @height 540

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(me: %{x: 320, y: 320}, width: @width, height: @height, time: 0)
     |> schedule_tick()}
  end

  @impl true
  def handle_event("move", %{"key" => key}, socket = %{assigns: %{me: me = %{x: x, y: y}}}) do
    case key do
      "w" -> {:noreply, assign(socket, me: %{me | y: max(0, y - 30)})}
      "a" -> {:noreply, assign(socket, me: %{me | x: max(0, x - 30)})}
      "d" -> {:noreply, assign(socket, me: %{me | x: min(@width - 1, x + 30)})}
    end
  end

  @impl true
  def handle_info(:tick, socket) do
    new_socket =
      socket
      |> add_gravity()
      |> calc_time()
      |> schedule_tick()

    {:noreply, new_socket}
  end

  defp add_gravity(socket = %{assigns: %{me: me = %{y: y}}}) do
    assign(socket, me: %{me | y: min(@height - 1, y + 3)})
  end

  defp calc_time(socket = %{assigns: %{time: time}}) do
    assign(socket, time: time + 1 / 30)
  end

  defp schedule_tick(socket) do
    Process.send_after(self(), :tick, 30)
    socket
  end
end
