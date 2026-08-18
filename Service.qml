import QtQuick
import Quickshell.Io

Item {
  id: root

  property bool active: false
  property string lastError: ""
  readonly property bool inhibitorRunning: inhibitorProcess.running

  function setActive(value) {
    var next = !!value
    if (next === active) return next ? "enabled" : "disabled"

    active = next
    lastError = ""
    inhibitorProcess.running = next
    return next ? "enabled" : "disabled"
  }

  function toggle() {
    return setActive(!active)
  }

  Component.onDestruction: inhibitorProcess.running = false

  Process {
    id: inhibitorProcess

    command: [
      "/usr/bin/systemd-inhibit",
      "--what=handle-lid-switch",
      "--mode=block",
      "--who=Omarchy",
      "--why=Stay awake while laptop lid is closed",
      "/usr/bin/sleep",
      "infinity"
    ]
    onExited: function(exitCode) {
      if (!root.active) return

      root.active = false
      root.lastError = exitCode === 0
        ? "Lid-close wake inhibitor stopped"
        : "Could not stay awake when lid closes"
    }
  }

  IpcHandler {
    target: "tahler.lid-awake"

    function status(): string {
      return JSON.stringify({
        active: root.active,
        inhibitorRunning: root.inhibitorRunning,
        error: root.lastError
      })
    }

    function enable(): string {
      return root.setActive(true)
    }

    function disable(): string {
      return root.setActive(false)
    }

    function toggle(): string {
      return root.toggle()
    }
  }
}
