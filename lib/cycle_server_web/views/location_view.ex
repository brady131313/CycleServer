defmodule CycleWeb.LocationView do
  use CycleWeb, :view

  def render("location.json", %{location: location}) do
    %{
      country: location.country,
      region: location.region
    }
  end
end
