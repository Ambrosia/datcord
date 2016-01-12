defmodule Datcord.MessageBuilder do
  @moduledoc """
  Helper to easily and properly build messages to send

  With user structs and pipes, mentioning a user or inserting their name
  becomes a very easy task. Lists of users are also supported.

  One minor quirk: it's currently not possible to pass a separator to
  `message/2` or `name/2` (i.e. beginning the pipeline). You will
  have to pass an empty `Message` struct yourself. This should not affect
  function calls anywhere else in the pipeline.

  ## Example

      iex> text("Hi ") |> mention(user) |> text("!")
      %Message{content: "Hi <@1>!", nonce: nil, tts: false}

      iex> mention(user) |> text(": ") |> name(friends) |> text(" are waiting for you")
      %Message{content: "<@1>: john, john2 and ANIME LEGEND 420 are waiting for you",
        nonce: nil, tts: false}
  """

  alias Datcord.Model.User

  defmodule Message do
    @moduledoc """
    Data for `MessageBuilder`.

    This can be passed to API functions that require a message to be sent.
    """
    defstruct content: "", nonce: nil, tts: false

    @type t :: %Message{}
  end

  @doc """
  Appends text to a `Message`.

  If a `Message` isn't passed as the first argument, a blank one will be used.
  """
  @spec text(Message.t, String.t) :: Message.t
  def text(message \\ %Message{}, string)

  def text(message = %Message{content: old_content}, content) do
    %{message | content: old_content <> content}
  end

  @doc """
  Appends username(s) to a `Message` and mentions them.

  If a `Message` isn't passed as the first argument, a blank one will be used.
  """
  @spec mention(Message.t, User.t | [User.t], Keyword.t) :: Message.t
  def mention(message \\ %Message{}, user, opts \\ [])

  def mention(message, users, opts) when is_list(users) do
    separator = Keyword.get(opts, :separator, &list_to_english_list/1)
    text(message, users |> user_ids_in_content(separator))
  end

  def mention(message, user, _opts) do
    text(message, user |> user_id_in_content)
  end

  @doc """
  Appends username(s) to a `Message`.

  If a `Message` isn't passed as the first argument, a blank one will be used.
  """
  @spec name(Message.t, User.t | [User.t], Keyword.t) :: Message.t
  def name(message \\ %Message{}, user, opts \\ [])

  def name(message, users, opts) when is_list(users) do
    separator = Keyword.get(opts, :separator, &list_to_english_list/1)
    text(message, users |> user_names_in_content(separator))
  end

  def name(message, user, _opts) do
    text(message, user |> user_name_in_content)
  end

  @spec user_ids_in_content([User.t], ([String.t] -> String.t)) :: String.t
  defp user_ids_in_content(users, separator) when is_list(users) do
    string_list = users |> Enum.map(&user_id_in_content/1)
    separator.(string_list)
  end

  @spec user_id_in_content(User.t) :: String.t
  defp user_id_in_content(%User{id: id}), do: "<@#{id}>"

  @spec user_names_in_content([User.t], ([String.t] -> String.t)) :: String.t
  defp user_names_in_content(users, separator) when is_list(users) do
    string_list = users |> Enum.map(&user_name_in_content/1)
    separator.(string_list)
  end

  @spec user_name_in_content(User.t) :: String.t
  defp user_name_in_content(%User{username: u}), do: u

  @doc """
  Converts a list of strings into a list in English

  ## Example
  iex> list_to_english_list([])
  ""

  iex> list_to_english_list(["Hey"])
  "Hey"

  iex> list_to_english_list(["Apples", "oranges"])
  "Apples and oranges"

  iex> list_to_english_list(["Apples", "oranges", "berries", "pears"])
  "Apples, oranges, berries and pears"
  """
  @spec list_to_english_list([String.t]) :: String.t
  def list_to_english_list([]), do: ""
  def list_to_english_list([elem]), do: elem

  def list_to_english_list(list) do
    {first_list, second_list} = Enum.split(list, -2)

    case Enum.join(first_list, ", ") do
      "" -> Enum.join(second_list, " and ")
      x -> x <> ", " <> Enum.join(second_list, " and ")
    end
  end
end
