defmodule Cycle.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add(:title, :string, null: false)
      add(:url, :string, null: false)

      timestamps()
    end
  end
end
