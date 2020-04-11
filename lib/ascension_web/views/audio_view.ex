defmodule AscensionWeb.AudioView do
  use AscensionWeb, :view
  alias AscensionWeb.AudioView

  def render("index.json", %{audio: audio}) do
    %{data: render_many(audio, AudioView, "audio.json")}
  end

  def render("show.json", %{audio: audio}) do
    %{data: render_one(audio, AudioView, "audio.json")}
  end

  def render("show_many.json", %{audio: audio}) do
    %{data: render_many(audio, AudioView, "audio.json")}
  end

  def render("audio.json", %{audio: audio}) do
    %{id: audio.id,
      title: audio.title,
      length: audio.length,
      book_id: audio.book_id,
      progress: audio.progress
    }
  end
end
