import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property string timeStr: "00:00"

    Process {
        id: dateProc
        command: ["date", "+%H:%M:%S"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.timeStr = this.text.trim();
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                required property var modelData
                screen: modelData

                anchors {
                    top: true
                    left: true
                    right: true
                }

                implicitHeight: 20

                color: "#1e2e2e"
                exclusionMode: PanelWindow.ExclusionMode.Exclusive

                Item {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Hyprland"
                        color: "#cdd6f4"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.timeStr
                        color: "#f5c2e7"
                        font.pixelSize: 15
                        font.bold: true
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: "80% | 100%"
                        color: "#a6e3a1"
                        font.pixelSize: 14
                    }
                }
            }
        }
    }
}
