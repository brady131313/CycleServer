defmodule Cycle.Articles.Crawler do
  def scrap_title(url) do
    with {:ok, uri} <- parse_url(url),
         {:ok, %Finch.Response{body: body}} <- request(uri),
         {:ok, document} <- Floki.parse_document(body),
         [{"title", _, [title]}] <- Floki.find(document, "title") do
      {:ok, title}
    end
  end

  defp parse_url(url) when not is_nil(url) do
    uri = URI.parse(url)

    if uri.scheme in ["https", "http"] do
      {:ok, uri}
    else
      {:error, "invalid url"}
    end
  end

  defp parse_url(_), do: {:error, "url can't be nil"}

  defp request(url) do
    Finch.build(:get, url)
    |> Finch.request(CycleFinch)
  end
end
