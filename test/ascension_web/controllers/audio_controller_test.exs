defmodule AscensionWeb.AudioControllerTest do
  use AscensionWeb.ConnCase

  alias Ascension.Books
  alias Ascension.Books.Audio

  @create_attrs %{
    length: 42,
    path: "some path",
    title: "some title"
  }
  @update_attrs %{
    length: 43,
    path: "some updated path",
    title: "some updated title"
  }
  @invalid_attrs %{length: nil, path: nil, title: nil}

  def fixture(:audio) do
    {:ok, audio} = Books.create_audio(@create_attrs)
    audio
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all audio", %{conn: conn} do
      conn = get(conn, Routes.audio_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create audio" do
    test "renders audio when data is valid", %{conn: conn} do
      conn = post(conn, Routes.audio_path(conn, :create), audio: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.audio_path(conn, :show, id))

      assert %{
               "id" => id,
               "length" => 42,
               "path" => "some path",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.audio_path(conn, :create), audio: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update audio" do
    setup [:create_audio]

    test "renders audio when data is valid", %{conn: conn, audio: %Audio{id: id} = audio} do
      conn = put(conn, Routes.audio_path(conn, :update, audio), audio: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.audio_path(conn, :show, id))

      assert %{
               "id" => id,
               "length" => 43,
               "path" => "some updated path",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, audio: audio} do
      conn = put(conn, Routes.audio_path(conn, :update, audio), audio: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete audio" do
    setup [:create_audio]

    test "deletes chosen audio", %{conn: conn, audio: audio} do
      conn = delete(conn, Routes.audio_path(conn, :delete, audio))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.audio_path(conn, :show, audio))
      end
    end
  end

  defp create_audio(_) do
    audio = fixture(:audio)
    {:ok, audio: audio}
  end
end
