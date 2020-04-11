defmodule Ascension.BooksTest do
  use Ascension.DataCase

  alias Ascension.Books

  describe "books" do
    alias Ascension.Books.Book

    @valid_attrs %{author: "some author", isbn: "some isbn", title: "some title"}
    @update_attrs %{author: "some updated author", isbn: "some updated isbn", title: "some updated title"}
    @invalid_attrs %{author: nil, isbn: nil, title: nil}

    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Books.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Books.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Books.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      assert {:ok, %Book{} = book} = Books.create_book(@valid_attrs)
      assert book.author == "some author"
      assert book.isbn == "some isbn"
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, %Book{} = book} = Books.update_book(book, @update_attrs)
      assert book.author == "some updated author"
      assert book.isbn == "some updated isbn"
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, @invalid_attrs)
      assert book == Books.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Books.change_book(book)
    end
  end

  describe "audio" do
    alias Ascension.Books.Audio

    @valid_attrs %{length: 42, path: "some path", title: "some title"}
    @update_attrs %{length: 43, path: "some updated path", title: "some updated title"}
    @invalid_attrs %{length: nil, path: nil, title: nil}

    def audio_fixture(attrs \\ %{}) do
      {:ok, audio} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Books.create_audio()

      audio
    end

    test "list_audio/0 returns all audio" do
      audio = audio_fixture()
      assert Books.list_audio() == [audio]
    end

    test "get_audio!/1 returns the audio with given id" do
      audio = audio_fixture()
      assert Books.get_audio!(audio.id) == audio
    end

    test "create_audio/1 with valid data creates a audio" do
      assert {:ok, %Audio{} = audio} = Books.create_audio(@valid_attrs)
      assert audio.length == 42
      assert audio.path == "some path"
      assert audio.title == "some title"
    end

    test "create_audio/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_audio(@invalid_attrs)
    end

    test "update_audio/2 with valid data updates the audio" do
      audio = audio_fixture()
      assert {:ok, %Audio{} = audio} = Books.update_audio(audio, @update_attrs)
      assert audio.length == 43
      assert audio.path == "some updated path"
      assert audio.title == "some updated title"
    end

    test "update_audio/2 with invalid data returns error changeset" do
      audio = audio_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_audio(audio, @invalid_attrs)
      assert audio == Books.get_audio!(audio.id)
    end

    test "delete_audio/1 deletes the audio" do
      audio = audio_fixture()
      assert {:ok, %Audio{}} = Books.delete_audio(audio)
      assert_raise Ecto.NoResultsError, fn -> Books.get_audio!(audio.id) end
    end

    test "change_audio/1 returns a audio changeset" do
      audio = audio_fixture()
      assert %Ecto.Changeset{} = Books.change_audio(audio)
    end
  end
end
