defmodule CycleWeb.ArticleController do
  use CycleWeb, :controller

  alias Cycle.Articles
  alias Cycle.Articles.Article

  action_fallback CycleWeb.FallbackController

  def index(conn, _params) do
    articles = Articles.list_articles()
    render(conn, "index.json", articles: articles)
  end

  def create(conn, %{"article" => article_params}) do
    with {:ok, %Article{} = article} <- Articles.create_article(article_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.article_path(conn, :show, article))
      |> render("show.json", article: article)
    end
  end

  def show(conn, %{"id" => id}) do
    article = Articles.get_article!(id)
    render(conn, "show.json", article: article)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Articles.get_article!(id)

    with {:ok, %Article{} = article} <- Articles.update_article(article, article_params) do
      render(conn, "show.json", article: article)
    end
  end

  def inc_likes(conn, %{"id" => id}) do
    article = Articles.get_article!(id)

    with {:ok, %Article{} = article} <- Articles.inc_article_likes(article) do
      render(conn, "show.json", article: article)
    end
  end

  def dec_likes(conn, %{"id" => id}) do
    article = Articles.get_article!(id)

    with {:ok, %Article{} = article} <- Articles.dec_article_likes(article) do
      render(conn, "show.json", article: article)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Articles.get_article!(id)

    with {:ok, %Article{}} <- Articles.delete_article(article) do
      send_resp(conn, :no_content, "")
    end
  end
end
