defmodule Cycle.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cycle.Articles.Location

  schema "articles" do
    field :title, :string
    field :url, :string
    belongs_to :location, Location

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :url])
    |> validate_required([:title, :url])
    |> cast_assoc(:location)
    |> unique_constraint(:title)
  end
end
