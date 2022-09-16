GC=go build

BUILD_DIR=build
PLUGIN_FLAGS=--buildmode=plugin
PLUGIN_BUILD_DIR=$(BUILD_DIR)/plugins

DEFAULT_VERSION=8.5.0
VERSION := $(or $(VERSION),$(DEFAULT_VERSION))
# load_proxy_plugin =
# ifeq ($(BILLING), true)
#     load_proxy_plugin = true
# endif
# ifeq ($(HOSTED_BILLING), true)
#     load_proxy_plugin = true
# endif
# ifeq ($(CLUSTER_BILLING), true)
#     load_proxy_plugin = true
# endif

# ifneq ($(load_proxy_plugin), true)
# 	TMPPLUGINS := $(PLUGINS)
# 	PLUGINS = $(filter-out proxy, $(TMPPLUGINS))
# endif

PLUGINS=analytics applycache cache pipelines uibuilder proxy fusion suggestions
PLUGIN_LOCS=$(foreach PLUGIN,$(PLUGINS),$(PLUGIN_BUILD_DIR)/$(PLUGIN).so)

$(info PLUGINS is $(PLUGINS))

OSS_PLUGINS=auth permissions users nodes telemetry querytranslate
OSS_PLUGIN_LOCS=$(foreach OSS_PLUGIN,$(OSS_PLUGINS),$(PLUGIN_BUILD_DIR)/$(OSS_PLUGIN).so)

cmd: plugins
	$(GC) -ldflags "-w -X main.Billing=$(BILLING) -X main.HostedBilling=$(HOSTED_BILLING) -X main.ClusterBilling=$(CLUSTER_BILLING) -X main.Opensource=$(OPENSOURCE) -X main.PlanRefreshInterval=$(PLAN_REFRESH_INTERVAL) -X main.IgnoreBillingMiddleware=$(IGNORE_BILLING_MIDDLEWARE) -X main.Tier=$(TEST_TIER) -X main.FeatureCustomEvents=$(TEST_FEATURE_CUSTOM_EVENTS) -X main.FeatureSuggestions=$(TEST_FEATURE_SUGGESTIONS) -X main.Version=$(VERSION)" -o $(BUILD_DIR)/serverless-search github.com/appbaseio/reactivesearch-api

plugins: $(PLUGIN_LOCS) $(OSS_PLUGIN_LOCS)
 
$(OSS_PLUGIN_LOCS): %.so:
	$(GC) $(PLUGIN_FLAGS) -o $@ github.com/appbaseio/reactivesearch-api/plugins/$(*F)/main

$(PLUGIN_LOCS): %.so:
	$(GC) $(PLUGIN_FLAGS) -o $@ github.com/appbaseio-confidential/arc-noss/plugins/$(*F)/main

clean:
	rm -rf $(BUILD_DIR)
