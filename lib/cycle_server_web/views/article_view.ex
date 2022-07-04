defmodule CycleWeb.ArticleView do
  use CycleWeb, :view
  alias CycleWeb.ArticleView

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{data: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{
      id: article.id,
      title: article.title,
      url: article.url,
      inserted_at: article.inserted_at,
      updated_at: article.updated_at
    }
  end
end
