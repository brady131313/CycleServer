defmodule Cycle.Articles.Location do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Cycle.Articles.Article

  schema "locations" do
    field :country, :string
    field :region, :string
    has_many :articles, Article
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:country, :region])
    |> validate_required([:country])
    |> unique_constraint([:country])
    |> unique_constraint([:country, :region])
  end

  def by_country_and_region(query \\ __MODULE__, country, region)

  def by_country_and_region(query, country, nil) do
    from(l in query, where: l.country == ^country and is_nil(l.region))
  end

  def by_country_and_region(query, country, region) do
    from(l in query, where: l.country == ^country and l.region == ^region)
  end
end
