defmodule Cycle.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast_assoc(:location)
    |> unique_constraint(:title)
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
