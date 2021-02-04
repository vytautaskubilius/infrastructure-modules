package test

import (
	"fmt"
	"strings"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"

	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestStaticWebsite(t *testing.T) {
	uniqueID := strings.ToLower(random.UniqueId())
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/static-website",
		Vars: map[string]interface{}{
			"hosted_zone_id": "Z07123232BCA88AAFKL8H",
			"hostname":       fmt.Sprintf("%s.dontpanic.lt", uniqueID),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	hostnames := terraform.OutputList(t, terraformOptions, "dns_records")
	for _, hostname := range hostnames {
		url := fmt.Sprintf("https://%s", hostname)
		http_helper.HttpGetWithRetry(t, url, nil, 200, "OK", 30, 5*time.Second)
	}
}
