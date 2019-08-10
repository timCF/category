defmodule Category.Data.Maybe do
  use Calculus
  use Category.TypeClass

  @moduledoc """
  Classic sum type `Maybe`.
  Implements Monad, Functor and Applicative behaviours.
  """

  defmacrop justp(x) do
    quote location: :keep do
      {:justp, unquote(x)}
    end
  end

  defmacrop nothingp, do: :nothingp

  @fetch_error "Can't fetch from #{inspect(__MODULE__)}.nothing"

  defcalculus state do
    :fetch ->
      case state do
        justp(x) -> calculus(state: state, return: x)
        nothingp() -> calculus(state: state, return: nil)
      end

    :fetch! ->
      case state do
        justp(x) -> calculus(state: state, return: x)
        nothingp() -> raise(@fetch_error)
      end

    method when method in [:is_just?, :is_nothing?] ->
      case state do
        justp(_) -> calculus(state: state, return: method == :is_just?)
        nothingp() -> calculus(state: state, return: method == :is_nothing?)
      end

    {:functor_fmap, f} ->
      case state do
        justp(x) -> calculus(state: justp(f.(x)), return: :ok)
        nothingp() -> calculus(state: state, return: :ok)
      end

    {:monad_bind, f} ->
      case state do
        justp(x) -> calculus(state: state, return: f.(x))
        nothingp() -> calculus(state: state, return: nothing())
      end

    {:applicative_ap, mf} ->
      case is_just?(mf) do
        true ->
          case state do
            justp(x) -> calculus(state: justp(fetch!(mf).(x)), return: :ok)
            nothingp() -> calculus(state: state, return: :ok)
          end

        false ->
          calculus(state: nothingp(), return: :ok)
      end
  end

  @typep a :: Category.a()

  @spec just(a) :: t
  def just(x), do: x |> justp() |> construct()

  @spec nothing :: t
  def nothing, do: nothingp() |> construct()

  @spec fetch(t) :: a | nil
  def fetch(it), do: it |> eval(:fetch) |> return()

  @spec fetch!(t) :: a | no_return
  def fetch!(it), do: it |> eval(:fetch!) |> return()

  @spec is_just?(t) :: boolean
  def is_just?(it), do: it |> eval(:is_just?) |> return()

  @spec is_nothing?(t) :: boolean
  def is_nothing?(it), do: it |> eval(:is_nothing?) |> return()

  @behaviour Functor
  @impl true
  def functor_fmap(f, it), do: it |> eval({:functor_fmap, f})

  @behaviour Monad
  @impl true
  def monad_bind(it, f), do: it |> eval({:monad_bind, f}) |> return()

  @behaviour Applicative
  @impl true
  def applicative_ap(mf, it), do: it |> eval({:applicative_ap, mf})
end
