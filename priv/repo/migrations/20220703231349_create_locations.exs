defmodule Cycle.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add(:country, :string, null: false)
      add(:region, :string)
    end

    # Two unique indexes so postgres recognizes region of nil as seperate value
    # which will trigger unique constraint
    create(unique_index(:locations, [:country, :region], where: "region IS NOT NULL"))
    create(unique_index(:locations, :country, where: "region IS NULL"))

    alter table(:articles) do
      add(:location_id, references(:locations))
      add(:likes, :integer, null: false, default: 0)
    end

    # Two unique indexes so postgres recognizes region of nil as seperate value
    # which will trigger unique constraint
    create(unique_index(:articles, [:title, :location_id], where: "location_id IS NOT NULL"))
    create(unique_index(:articles, :title, where: "location_id IS NULL"))
  end
end
