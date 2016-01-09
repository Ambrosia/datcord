defmodule DiscordElixir.API.Authentication do
  @moduledoc """
  Discord authentication.
  """

  alias DiscordElixir.API

  @doc """
  Logs in to Discord with the given email and password.

  Returns `{:ok, token}` on success or `{:error, errors}` on error.
  """
  @spec login(String.t, String.t) :: {:ok, String.t} | {:error, [String.t]}
  def login(email, password) do
    params = %{email: email, password: password}
    with {:ok, response} <- API.post(login_url, params),
         {:ok, token} <- parse_login_response(response.body),
         do: {:ok, token}
  end

  defp parse_login_response(%{"email" => errors}), do: {:error, errors}
  defp parse_login_response(%{"password" => errors}), do: {:error, errors}
  defp parse_login_response(%{"token" => token}), do: {:ok, token}

  defp parse_logout_response(map) when map == %{}, do: :ok

  defp auth_url, do: "/auth"
  defp login_url, do: auth_url <> "/login"
  defp logout_url, do: auth_url <> "/logout"
end
