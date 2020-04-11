defmodule Ascension.Repo.Migrations.AddAudioProgress do
  use Ecto.Migration

  def change do
    alter table(:audio) do
      add :progress, :integer
    end
  end
end
