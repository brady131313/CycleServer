defmodule Cycle.ArticlesTest do
  use Cycle.DataCase

  alias Cycle.Articles

  describe "articles" do
    alias Cycle.Articles.{Article, Location}

    import Cycle.ArticlesFixtures

    @invalid_attrs %{title: nil, url: nil}

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Articles.list_articles() == [%{article | location: nil}]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Articles.get_article!(article.id) == %{article | location: nil}
    end

    test "create_article/1 with valid data creates a article" do
      valid_attrs = %{title: "some title", url: "some url"}

      assert {:ok, %Article{} = article} = Articles.create_article(valid_attrs)
      assert article.title == "some title"
      assert article.url == "some url"
    end

    test "create_article/1 with existing location" do
      assert {:ok, _} = Articles.create_location(%{country: "Iceland"})
      assert length(Articles.list_locations()) == 1
      valid_attrs = %{title: "some title", url: "some url", location: %{country: "Iceland"}}

      assert {:ok, %Article{} = article} = Articles.create_article(valid_attrs)
      assert %Location{country: "Iceland"} = article.location
      assert length(Articles.list_locations()) == 1
    end

    test "create_article/1 with new location" do
      valid_attrs = %{title: "some title", url: "some url", location: %{country: "France"}}
      assert length(Articles.list_locations()) == 0

      assert {:ok, %Article{} = article} = Articles.create_article(valid_attrs)
      assert %Location{country: "France"} = article.location
      assert length(Articles.list_locations()) == 1
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      update_attrs = %{title: "some updated title", url: "some updated url"}

      assert {:ok, %Article{} = article} = Articles.update_article(article, update_attrs)
      assert article.title == "some updated title"
      assert article.url == "some updated url"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Articles.update_article(article, @invalid_attrs)
      assert %{article | location: nil} == Articles.get_article!(article.id)
    end

    test "inc_article_likes/1 increments article like count" do
      article = article_fixture()
      assert {:ok, %Article{likes: 1}} = Articles.inc_article_likes(article)
    end

    test "dec_article_likes/1 decrements article like count" do
      article = article_fixture()
      assert {:ok, %Article{likes: -1}} = Articles.dec_article_likes(article)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Articles.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Articles.change_article(article)
    end
  end
end
