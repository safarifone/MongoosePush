defmodule MongoosePush.API.V2.ResponseEncoder do
  @moduledoc """
  Module for handling internal responses to V2 HTTP2 codes
  """
  @behaviour MongoosePush.API
  alias MongoosePush.Service

  @spec to_status(:ok | {:error, Service.error() | {:error, MongoosePush.error()}}) ::
          {non_neg_integer, %{details: atom | String.t()} | nil}
  def to_status(:ok), do: {200, nil}

  def to_status({:error, {:generic, :unable_to_connect}}) do
    {503, %{:details => "Please try again later"}}
  end

  def to_status({:error, {_type, reason}}) when is_atom(reason) do
    {500, %{:details => reason}}
  end

  def to_status({:error, reason}) when is_atom(reason) do
    try do
      code = Plug.Conn.Status.code(reason)
      reason_phrase = Plug.Conn.Status.reason_phrase(code)
      {code, %{:details => reason_phrase}}
    catch
      # We really don't care what happened here, we have to return something
      _, _ ->
        {500, %{:details => reason}}
    end
  end

  def to_status({:error, _reason}) do
    {500, nil}
  end
end
