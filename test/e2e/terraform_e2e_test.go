package e2e

import (
	"regexp"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// func TestExamplesS2sVPN(t *testing.T) {
// 	test_helper.RunE2ETest(t, "../../", "examples/s2svpn", terraform.Options{
// 		Upgrade: true,
// 	}, func(t *testing.T, output test_helper.TerraformOutput) {
// 		virtualNetworkGatewayId, ok := output["s2s_vpn_gw_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworkGateways/.+"), virtualNetworkGatewayId)
// 		publicIpAddressId, ok := output["test_public_ip_address_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/publicIPAddresses/.+"), publicIpAddressId)
// 	})
// }

// func TestExamplesER(t *testing.T) {
// 	test_helper.RunE2ETest(t, "../../", "examples/er", terraform.Options{
// 		Upgrade: true,
// 	}, func(t *testing.T, output test_helper.TerraformOutput) {
// 		virtualNetworkGatewayId, ok := output["test_virtual_network_gateway_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworkGateways/.+"), virtualNetworkGatewayId)
// 		publicIpAddressId, ok := output["test_public_ip_address_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/publicIPAddresses/.+"), publicIpAddressId)
// 	})
// }

// func TestExamplesP2sVPN(t *testing.T) {
// 	test_helper.RunE2ETest(t, "../../", "examples/P2svpn", terraform.Options{
// 		Upgrade: true,
// 	}, func(t *testing.T, output test_helper.TerraformOutput) {
// 		virtualNetworkGatewayId, ok := output["test_virtual_network_gateway_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworkGateways/.+"), virtualNetworkGatewayId)
// 		publicIpAddressId, ok := output["test_public_ip_address_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/publicIPAddresses/.+"), publicIpAddressId)
// 	})
// }

// func TestExamplesVanilla(t *testing.T) {
// 	test_helper.RunE2ETest(t, "../../", "examples/vanilla", terraform.Options{
// 		Upgrade: true,
// 	}, func(t *testing.T, output test_helper.TerraformOutput) {
// 		virtual_hub_id, ok := output["virtual_hub_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualHubs/.+"), virtual_hub_id)
// 	})
// }

func TestExamplesVwan(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/basic", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		virtual_wan_id, ok := output["virtual_wan_id"].(string)
		assert.True(t, ok)
		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualWans/.+"), virtual_wan_id)
	})
}

// func TestExamplesFirewall(t *testing.T) {
// 	test_helper.RunE2ETest(t, "../../", "examples/vnet-firewall-routingintent", terraform.Options{
// 		Upgrade: true,
// 	}, func(t *testing.T, output test_helper.TerraformOutput) {
// 		virtualNetworkGatewayId, ok := output["test_virtual_network_gateway_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworkGateways/.+"), virtualNetworkGatewayId)
// 		publicIpAddressId, ok := output["test_public_ip_address_id"].(string)
// 		assert.True(t, ok)
// 		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/publicIPAddresses/.+"), publicIpAddressId)
// 	})
// }
