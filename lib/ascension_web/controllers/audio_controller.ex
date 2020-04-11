defmodule AscensionWeb.AudioController do
  use AscensionWeb, :controller
  use Bitwise

  alias Ascension.Books
  alias Ascension.Books.Audio

  action_fallback AscensionWeb.FallbackController

  def index(conn, _params) do
    audio = Books.list_audio()
    render(conn, "index.json", audio: audio)
  end

  defp get_mp3_duration(mp3_path) do
    {:ok, file} = File.open mp3_path
    file_size = get_file_size mp3_path
    <<_, version_layer, bitrate>> = IO.binread(file, 3)
    bitrateIndex = 240 &&& bitrate
    mpegLayer = 6 &&& version_layer
    mpegVersion = 24 &&& version_layer

    Integer.floor_div 8 * file_size, 320000
  end

  defp create_for_all_files([ upload | tail ], book_id, accumulator) do
    root_name = Path.rootname upload.filename
    File.cp(upload.path, "media/#{upload.filename}")
    length = get_mp3_duration("media/#{upload.filename}")
    parsed_audio_params = %{ title: root_name, path: "/home/andreas/testboi/#{upload.filename}", length: length, book_id: book_id, progress: 0}

    IO.inspect(parsed_audio_params)
    case Books.create_audio(parsed_audio_params) do
      {:ok, %Audio{} = audio} ->
        create_for_all_files(tail, book_id, [ audio | accumulator ])
      {:error, _ } ->
        create_for_all_files(tail, book_id, accumulator)
    end
  end

  defp create_for_all_files([], _, accumulator) do
    accumulator
  end

  def create(conn, audio_params) do
    if upload = audio_params["audio"] do
        files = create_for_all_files(upload, audio_params["book_id"], [])

        conn
        |> put_status(:created)
        |> render("show_many.json", audio: files)
    end
  end

  def update_progress(conn, %{"id" => id, "progress" => progress}) do
    audio = Books.get_audio!(id)
    case Books.update_audio(audio, %{ id: id, progress: progress }) do
      {:ok, new_audio } ->
        render(conn, "show.json", audio: new_audio)
    end
  end

  def show(conn, %{"id" => id}) do
    audio = Books.get_audio!(id)
    offset = get_offset(conn)
    file_size = get_file_size(audio.path)

    conn
    |> put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
    |> put_resp_header("content-type", "audio/mpeg")
    |> send_file(206, audio.path, offset, file_size - offset)
  end

  defp get_offset(conn) do
      case List.keyfind(conn.req_headers, "range", 0) do
          { "range", "bytes=" <> start_pos } -> 
              String.split(start_pos, "-") |> hd |> String.to_integer
      nil ->
            0
      end
  end

  defp get_file_size(path) do
      { :ok, %{size: size}} = File.stat path

      size
  end

  def notshow(conn, %{"id" => id}) do
    audio = Books.get_audio!(id)
    render(conn, "show.json", audio: audio)
  end

  def update(conn, %{"id" => id, "audio" => audio_params}) do
    audio = Books.get_audio!(id)

    with {:ok, %Audio{} = audio} <- Books.update_audio(audio, audio_params) do
      render(conn, "show.json", audio: audio)
    end
  end

  def delete(conn, %{"id" => id}) do
    audio = Books.get_audio!(id)

    with {:ok, %Audio{}} <- Books.delete_audio(audio) do
      send_resp(conn, :no_content, "")
    end
  end
end
