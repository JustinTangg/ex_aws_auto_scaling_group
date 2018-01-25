if Code.ensure_loaded?(SweetXml) do
  defmodule ExAws.AutoScalingGroup.Parsers do
    use ExAws.Operation.Query.Parser
    
    def parse({:ok, %{body: xml} = resp}, :describe_auto_scaling_groups) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeAutoScalingGroupsResponse",
          auto_scaling_groups: auto_scaling_groups_xml_description(),
          next_token: ~x"./DescribeAutoScalingGroupsResult/NextToken/text()"s,
          request_id: ~x"./ResponseMetaData/RequestId/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def auto_scaling_groups_xml_description do
      [
        ~x"./DescribeAutoScalingGroupsResult/AutoScalingGroups/member"l,
        auto_scaling_group_arn: ~x"./AutoScalingGroupARN/text()"s,
        auto_scaling_group_name: ~x"./AutoScalingGroupName/text()"s,
        availability_zones: ~x"./AvailabilityZones/member/text()"ls,
        created_time: ~x"./CreatedTime/text()"s,
        default_cooldown: ~x"./DefaultCooldown/text()"i,
        desired_capacity: ~x"./DesiredCapacity/text()"i,
        enabled_metrics: [
          ~x"./EnabledMetrics/member"l,
          granularity: ~x"./Granularity/text()"s,
          metric: ~x"./Metric/text()"s
        ],
        health_check_grace_period: ~x"./HealthCheckGracePeriod/text()"i,
        health_check_type: ~x"./HealthCheckType/text()"s,
        instances: [
          ~x"./Instances/member"l,
          availability_zone: ~x"./AvailabilityZone/text()"s,
          health_status: ~x"./HealthStatus/text()"s,
          instance_id: ~x"./InstanceId/text()"s,
          launch_configuration_name: ~x"./LaunchConfigurationName/text()"s,
          launch_template: ~x"./LaunchTemplate/text()"s,
          lifecycle_state: ~x"./LifecycleState/text()"s,
          protected_from_scale_in: ~x"./ProtectedFromScaleIn/text()"s |> to_boolean()
        ],
        launch_configuration_name: ~x"./LaunchConfigurationName/text()"s,
        launch_template: ~x"./LaunchTemplate/text()"s,
        load_balancer_names: ~x"./LoadBalancerNames/member/text()"ls,
        max_size: ~x"./MaxSize/text()"i,
        min_size: ~x"./MinSize/text()"i,
        new_instances_protected_from_scale_in: ~x"./NewInstancesProtectedFromScaleIn/text()"s |> to_boolean(),
        placement_group: ~x"./PlacementGroup/text()"s,
        status: ~x"./Status/text()"s,
        suspended_processes: [
          ~x"./SuspendedProcesses/member"l,
          process_name: ~x"./ProcessName/text()"s,
          suspension_reason: ~x"./SuspensionReason/text()"s
        ],
        tags: [
          ~x"./Tags/member"l,
          key: ~x"./Key/text()"s,
          propagate_at_launch: ~x"./PropagateAtLaunch/text()"s |> to_boolean(),
          resource_id: ~x"./ResourceId/text()"s,
          resource_type: ~x"./ResourceType/text()"s,
          value: ~x"./Value/text()"s
        ],
        target_group_arns: ~x"./TargetGroupARNS/member/text()"ls,
        termination_policies: ~x"./TerminationPolicies/member/text()"ls,
        vpc_zone_identifier: ~x"./VPCZoneIdentifier/text()"s
      ]
    end

    defp to_boolean(xpath) do
      xpath |> SweetXml.transform_by(&(&1 == "true"))
    end
  end
end