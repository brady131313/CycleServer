defmodule CycleWeb.ArticleView do
  use CycleWeb, :view
  alias Cycle.Articles.Location
  alias CycleWeb.{ArticleView, LocationView}

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{data: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    location =
      if is_struct(article.location, Location) do
        render_one(article.location, LocationView, "location.json")
      end

    %{
      id: article.id,
      title: article.title,
      url: article.url,
      likes: article.likes,
      inserted_at: article.inserted_at,
      updated_at: article.updated_at,
      location: location
    }
  end
end
