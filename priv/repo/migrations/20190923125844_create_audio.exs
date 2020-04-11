defmodule Ascension.Repo.Migrations.CreateAudio do
  use Ecto.Migration

  def change do
    create table(:audio) do
      add :path, :string
      add :title, :string
      add :length, :integer
      add :book_id, references(:books, on_delete: :delete_all)

      timestamps()
    end

    create index(:audio, [:book_id])
  end
end
