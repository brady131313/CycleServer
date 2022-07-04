defmodule Cycle.Articles.Location do
  use Ecto.Schema
  import Ecto.Changeset

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
end
