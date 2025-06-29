import { ajax } from "discourse/lib/ajax";
import { withPluginApi } from "discourse/lib/plugin-api";

function initializePlugin(api) {
  const topicTrackingState = api._lookupContainer(
    "service:topic-tracking-state"
  );
  const siteSettings = api._lookupContainer("service:site-settings");
  if (siteSettings.preload_optimization_topic_tracking_state_mode === "async") {
    const currentUser = api.getCurrentUser();
    if (currentUser && currentUser.username) {
      ajax(`/u/${currentUser.username}/topic-tracking-state.json`).then(
        (data) => {
          topicTrackingState.loadStates(data);
          // Trigger UI rerender
          topicTrackingState.messageCount++;
        }
      );
    }
  }
}

export default {
  name: "preload-optimization",
  initialize: function () {
    withPluginApi("0.8.6", (api) => initializePlugin(api));
  },
};
