defmodule AscensionWeb.BookController do
  use AscensionWeb, :controller

  alias Ascension.Books
  alias Ascension.Books.Book

  action_fallback AscensionWeb.FallbackController

  def index(conn, _params) do
    books = Books.list_books()
    render(conn, "index.json", books: books)
  end

  def create(conn, %{"book" => book_params}) do
    with {:ok, %Book{} = book} <- Books.create_book(book_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.book_path(conn, :show, book))

      book = Ascension.Repo.preload(book, :audio)
      render(conn, "show.json", book: book)
    end
  end

  def show(conn, %{"id" => id}) do
    book = Books.get_book!(id)
    render(conn, "show.json", book: book)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Books.get_book!(id)

    with {:ok, %Book{} = book} <- Books.update_book(book, book_params) do
      render(conn, "show.json", book: book)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Books.get_book!(id)

    with {:ok, %Book{}} <- Books.delete_book(book) do
      send_resp(conn, :no_content, "")
    end
  end

  def isbn(conn, %{"isbn" => isbn, "author" => author, "title" => title}) do
    url = "http://openlibrary.org/search.json?"
    parameters = ""

    parameters = if String.length(isbn) > 0 do
      parameters <> "isbn=#{URI.encode_www_form(isbn)}&"
    else
      parameters
    end

    parameters = if String.length(title) > 0 do
      parameters <> "title=#{URI.encode_www_form(title)}&"
    else
      parameters
    end

    parameters = if String.length(author) > 0 do
      parameters <> "author=#{URI.encode_www_form(author)}"
    else 
      parameters
    end

    case HTTPoison.get(url <> parameters) do
      {:ok, %{status_code: 200, body: body}} ->
        req = Jason.decode!(body)
        %{ "num_found" => result_count } = req
        if result_count > 0 do
          book_results = Enum.map(req["docs"], fn x -> %{ :isbn => if Map.has_key?(x, "isbn") do hd(x["isbn"]) else "" end, :title => x["title_suggest"], :authors => x["author_name"] } end)
          render(conn, "books.json", books: book_results)
        else
          render(conn, "books.json", books: [])
        end

      {:ok, %{status_code: 404}} ->
        conn
        |> put_status(:error)
        |> render("error.json")
    end
  end
end
