defmodule Cycle.Articles do
  @moduledoc """
  The Articles context.
  """

  import Ecto.Query, warn: false
  alias Cycle.Repo

  alias Cycle.Articles.{Article, Location, Crawler}

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Article
    |> preload([], :location)
    |> Repo.all()
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id) do
    Article
    |> preload([], :location)
    |> Repo.get!(id)
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> maybe_scrap_title(attrs)
    |> Repo.insert()
  end

  defp maybe_scrap_title(changeset, attrs) do
    case Ecto.Changeset.get_field(changeset, :title) do
      nil -> scrap_title(changeset, attrs)
      _title -> changeset
    end
  end

  defp scrap_title(changeset, attrs) do
    url = Ecto.Changeset.get_field(changeset, :url)

    case Crawler.scrap_title(url) do
      {:ok, title} ->
        Article.changeset(%Article{title: title}, attrs)

      {:error, _} ->
        Ecto.Changeset.add_error(
          changeset,
          :title,
          "Title was not given and couldn't be scrapped from url."
        )
    end
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  def inc_article_likes(%Article{} = article) do
    article
    |> Article.inc_like_changeset()
    |> Repo.update()
  end

  def dec_article_likes(%Article{} = article) do
    article
    |> Article.dec_like_changeset()
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def list_locations() do
    Repo.all(Location)
  end

  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end
end
