# frozen_string_literal: true

# name: discourse-preload-optimization
# about: Delay some preloads from ApplicationLayoutPreloader to speed up initial page load.
# meta_topic_id: TODO
# version: 0.0.1
# authors: pangbo
# url: https://github.com/ShuiyuanSJTU/discourse-preload-optimization
# required_version: 2.7.0

enabled_site_setting :discourse_preload_optimization_enabled

module ::MyPluginModule
  PLUGIN_NAME = "discourse-preload-optimization"
end

after_initialize do
  module ::DiscoursePreloadOptimization
    module OverrideApplicationLayoutPreloader
      class TopicTrackingState < ::TopicTrackingState
        def self.report(*args)
          if SiteSetting.discourse_preload_optimization_enabled &&
               SiteSetting.preload_optimization_topic_tracking_state_mode != "sync"
            {}
          else
            super(*args)
          end
        end
      end
    end
  end
  reloadable_patch do
    ApplicationLayoutPreloader.prepend DiscoursePreloadOptimization::OverrideApplicationLayoutPreloader
  end
end
