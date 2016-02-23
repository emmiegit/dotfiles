from constants import *
from lemongadget import LemonGadget
import i3

WORKSPACE_FOCUSED = 0
WORKSPACE_ACTIVE = 1
WORKSPACE_INACTIVE = 2
WORKSPACE_URGENT = 3


class i3Handle(object):
    def __init__(self):
        self.state = None
        self.socket = None
        self.workspaces = None
        self.outputs = None
        self.subscription = None

    def start(self):
        self.socket = i3.Socket()
        self.subscription = i3.Subscription(self.refresh, "workspace")
        self.refresh()

    def refresh(self, event=None, data=None, subscription=None):
        self.workspaces = self.socket.get("get_workspaces")
        self.outputs = self.socket.get("get_outputs")

    def get_workspace_list(self):
        results = {}
        for workspace in self.workspaces:
            output = None
            for out in self.outputs:
                if out["name"] == workspace["output"]:
                    output = out
                    break
            if not output:
                continue
            name = workspace["name"]
            if output["name"] not in results.keys():
                results[output["name"]] = []
            results[output["name"]].append((name, self.get_state(workspace, output), output["name"]))
        return results

    def kill(self):
        self.subscription.close()

    @staticmethod
    def get_state(workspace, output):
        if workspace['focused']:
            if output['current_workspace'] == workspace['name']:
                return WORKSPACE_FOCUSED
            else:
                return WORKSPACE_ACTIVE
        if workspace['urgent']:
            return WORKSPACE_URGENT
        else:
            return WORKSPACE_INACTIVE


class WorkspacesGadget(LemonGadget):
    def __init__(self, cycle, alignment, monitor):
        super().__init__(cycle, alignment, wants="i3")
        self.i3_handle = i3Handle()
        self.monitor = monitor
        self.max_length = 600

    def update(self):
        lastbg = self._lastbg
        workspaces = self.i3_handle.get_workspace_list()[self.monitor]
        for index, (workspace, state, monitor) in enumerate(workspaces):
            if index == 0:
                if state == WORKSPACE_INACTIVE:
                    self.add_format(bg=INACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_ACTIVE or state == WORKSPACE_FOCUSED:
                    self.add_format(bg=ACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_URGENT:
                    self.add_format(bg=URGENT_WORKSPACE_COLOR)
                else:
                    raise ValueError("Invalid workspace state: %s" % state)

                self.append_icon(ICON_WORKSPACE)
                self.append_text(" ")
            else:
                if state == WORKSPACE_INACTIVE:
                    self.append_separator(INACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_ACTIVE or state == WORKSPACE_FOCUSED:
                    self.append_separator(ACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_URGENT:
                    self.append_separator(URGENT_WORKSPACE_COLOR)

            self.add_anchor(leftclick="i3-msg workspace %s" % workspace)
            self.append_text(" %s " % workspace)
            self.end_anchor()

            if index == len(workspaces) - 1:
                self.append_separator(lastbg)
