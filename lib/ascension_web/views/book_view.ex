defmodule AscensionWeb.BookView do
  use AscensionWeb, :view
  alias AscensionWeb.BookView

  def render("index.json", %{books: books}) do
    %{data: render_many(books, BookView, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, BookView, "book.json")}
  end

  def render("book.json", %{book: book}) do
    %{id: book.id,
      title: book.title,
      author: book.author,
      isbn: book.isbn,
      audio: book.audio
    }
  end

  def render("books.json", %{books: books}) do
    %{data: books}
  end
end
