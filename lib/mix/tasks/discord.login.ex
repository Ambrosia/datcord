defmodule Mix.Tasks.Discord.Login do
  @moduledoc """
  Generates an API token to use with Discord.

      mix discord.login email@example.com example_password

  On success, a new token usable with Discord is printed.

  If there's an error in your input (wrong/missing email or password),
  an error will be shown instead.
  """

  @invalid_arguments """
  mix discord.login expects an email and a password in the following format:

      mix discord.login email@example.com example_password
  """

  use Mix.Task
  alias Datcord.API.Authentication

  def run([email, password]) do
    {:ok, _} = Application.ensure_all_started(:httpoison)

    case Authentication.login(email, password) do
      {:ok, token} -> Mix.shell.info(token)
      {:error, errors} -> errors |> Enum.join(", ") |> Mix.shell.error
    end
  end

  def run(_), do: invalid_arguments

  def invalid_arguments, do: Mix.raise(@invalid_arguments)
end
