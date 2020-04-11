defmodule Ascension.Books.Audio do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:length, :title, :id, :book_id, :progress]}
  schema "audio" do
    field :length, :integer
    field :path, :string
    field :title, :string
    field :book_id, :id
    field :progress, :integer

    timestamps()
  end

  @doc false
  def changeset(audio, attrs) do
    audio
    |> cast(attrs, [:path, :title, :length, :book_id, :progress])
    |> validate_required([:path, :title, :length, :book_id])
  end
end
