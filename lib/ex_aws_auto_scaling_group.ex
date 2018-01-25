defmodule ExAwsAutoScalingGroup do
  @moduledoc """
  Documentation for ExAwsAutoScalingGroup.
  """

  use ExAws.Utils,
    format_type: :xml,
    non_standard_keys: %{}
  #version of the AWS API
  @version "2011-01-01"

  @type describe_auto_scaling_groups_opts :: [
    auto_scaling_group_names: [binary, ...],
    max_records: integer,
    next_token: binary
  ]
  @spec describe_auto_scaling_groups() :: ExAws.Operation.Query.t()
  @spec describe_auto_scaling_groups(opts :: describe_auto_scaling_groups_opts) :: ExAws.Operation.Query.t()
  def describe_auto_scaling_groups(opts \\ []) do
    opts |> build_request(:describe_auto_scaling_groups)
  end

  ####################
  # Helper Functions #
  ####################

  defp build_request(opts, action) do
    opts
    |> Enum.flat_map(&format_param/1)
    |> request(action)
  end

  defp request(params, action) do
    action_string = action |> Atom.to_string() |> Macro.camelize()

    %ExAws.Operation.Query{
      path: "/",
      params: params
              |> filter_nil_params
              |> Map.put("Action", action_string)
              |> Map.put("Version", @version),
      service: :monitoring,
      action: action,
      parser: &ExAws.AutoScalingGroup.Parsers.parse/2
    }
  end

  defp format_param({:auto_scaling_group_names, auto_scaling_group_names}) do
    auto_scaling_group_names |> format(prefix: "AutoScalingGroupNames.member")
  end

  defp format_param({key, parameters}) do
    format([ {key, parameters} ])
  end
end
