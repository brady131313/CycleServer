defmodule Cycle.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cycle.Repo

  alias Cycle.Articles
  alias Cycle.Articles.Location

  schema "articles" do
    field :title, :string
    field :url, :string
    field :likes, :integer, default: 0
    belongs_to :location, Location

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :url])
    |> validate_required([:title, :url])
    |> unique_constraint(:title)
    |> unique_constraint([:title, :location_id])
    |> put_assoc(:location, parse_location(attrs))
  end

  defp parse_location(%{"location" => location}),
    do: get_or_insert_location(location["country"], location["region"])

  defp parse_location(%{location: location}),
    do: get_or_insert_location(location[:country], location[:region])

  defp parse_location(_), do: nil

  defp get_or_insert_location(country, region) do
    Repo.one(Location.by_country_and_region(country, region)) ||
      maybe_insert_location(country, region)
  end

  defp maybe_insert_location(country, region) do
    case Articles.create_location(%{country: country, region: region}) do
      {:ok, location} -> location
      {:error, _} -> Repo.one!(Location.by_country_and_region(country, region))
    end
  end

  def inc_like_changeset(%{likes: likes} = article) do
    like_changeset(article, %{likes: likes + 1})
  end

  def dec_like_changeset(%{likes: likes} = article) do
    like_changeset(article, %{likes: likes - 1})
  end

  defp like_changeset(article, attrs) do
    article
    |> cast(attrs, [:likes])
    |> validate_required([:likes])
  end
end
