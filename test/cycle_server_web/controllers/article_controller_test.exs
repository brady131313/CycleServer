defmodule CycleWeb.ArticleControllerTest do
  use CycleWeb.ConnCase

  import Cycle.ArticlesFixtures

  alias Cycle.Articles.Article

  @create_attrs %{
    title: "some title",
    url: "some url"
  }
  @update_attrs %{
    title: "some updated title",
    url: "some updated url"
  }
  @invalid_attrs %{title: nil, url: nil}

# TODO: persist req headers between calls to get/post in tests

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:set_secret]

    test "lists all articles", %{conn: conn} do
      conn = get(conn, Routes.article_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create article" do
    setup [:set_secret]

    test "renders article when data is valid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.article_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "title" => "some title",
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update article" do
    setup [:create_article, :set_secret]

    test "renders article when data is valid", %{conn: conn, article: %Article{id: id} = article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.article_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "title" => "some updated title",
               "url" => "some updated url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "article likes" do
    setup [:create_article, :set_secret]

    test "renders article when like increment succeeds", %{
      conn: conn,
      article: %Article{id: id} = article
    } do
      conn = post(conn, Routes.article_path(conn, :inc_likes, article))
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.article_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "likes" => 1
             } = json_response(conn, 200)["data"]
    end

    test "renders article when like decrement succeeds", %{
      conn: conn,
      article: %Article{id: id} = article
    } do
      conn = post(conn, Routes.article_path(conn, :dec_likes, article))
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.article_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "likes" => -1
             } = json_response(conn, 200)["data"]
    end
  end

  describe "delete article" do
    setup [:create_article, :set_secret]

    test "deletes chosen article", %{conn: conn, article: article} do
      conn = delete(conn, Routes.article_path(conn, :delete, article))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.article_path(conn, :show, article))
      end
    end
  end

  defp create_article(_) do
    article = article_fixture()
    %{article: article}
  end

  defp set_secret(%{conn: conn}) do
    %{conn: put_req_header(conn, "secret", "test_client_secret")}
  end
end
