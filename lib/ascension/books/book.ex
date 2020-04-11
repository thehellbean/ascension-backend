defmodule Ascension.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :isbn, :string
    field :title, :string

    has_many :audio, Ascension.Books.Audio

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :isbn])
    |> validate_required([:title, :author, :isbn])
  end
end
