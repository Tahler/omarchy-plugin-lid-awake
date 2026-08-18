import QtQuick
import qs.Ui

BarWidget {
  id: root

  readonly property string serviceId: "io.github.tahler.lid-awake"
  readonly property var lidAwakeService: root.service()
  readonly property bool active: lidAwakeService ? lidAwakeService.active : false
  readonly property string inactiveTooltip: lidAwakeService
    ? (lidAwakeService.lastError || "Stay awake when lid is closed")
    : "Lid-close wake service unavailable"

  function service() {
    if (!bar || !bar.shell || typeof bar.shell.ensureService !== "function") return null
    return bar.shell.serviceFor(serviceId) || bar.shell.ensureService(serviceId)
  }

  function toggle() {
    var service = root.service()
    if (service) service.toggle()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button

    anchors.fill: parent
    bar: root.bar
    text: "󰌢"
    active: root.active
    useActiveColor: false
    dimmed: !root.active
    interactive: root.bar !== null
    tooltipText: root.active
      ? "Allow suspend when lid closes"
      : root.inactiveTooltip
    onPressed: root.toggle()
  }
}
