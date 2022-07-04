defmodule Cycle.ArticlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cycle.Articles` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url"
      })
      |> Cycle.Articles.create_article()

    article
  end
end
