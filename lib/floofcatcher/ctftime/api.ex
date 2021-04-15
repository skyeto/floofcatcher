defmodule Floofcatcher.Ctftime.Api do
  @ctftime "https://ctftime.org"
  @ctftime_api @ctftime <> "/api/v1/"

  def get_event(id) do
    raise "Not implemented"
  end

  def get_team(id) do
    # TODO: We can't use the API endpoint since it doesn't return
    # the description. :(
    with  {:ok, body} <- get_request(@ctftime, ["team", id]),
          {:ok, doc} <- Floki.parse_document(body) do
      %Floofcatcher.Ctftime.Team{
        id: id,
        name: Floofcatcher.Ctftime.Team.name_from_html(doc),
        country: Floofcatcher.Ctftime.Team.country_from_html(doc),
        description: Floofcatcher.Ctftime.Team.description_from_html(doc),
        logo: Floofcatcher.Ctftime.Team.logo_from_html(doc)
      }
    end
  end

  def url, do: @ctftime

  defp get_request(endpoint, args) do
    result = build_url(endpoint, args) |> HTTPoison.get
    case result do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      _ ->
        :error
    end
  end

  defp build_url(endpoint, args) do
    endpoint <> "/" <> Enum.join(args, "/")
  end
end
