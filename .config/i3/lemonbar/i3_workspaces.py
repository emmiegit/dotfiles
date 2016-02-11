import i3

WORKSPACE_FOCUSED = 0
WORKSPACE_ACTIVE = 1
WORKSPACE_INACTIVE = 2
WORKSPACE_URGENT = 3


class i3Handle(object):
    def __init__(self, monitor=None):
        self.state = None
        self.socket = i3.Socket()
        self.workspaces = None
        self.outputs = None
        self.monitor = monitor
        self.refresh()
        self.subscription = i3.Subscription(self.refresh, "workspace")

    def refresh(self, *args):
        self.workspaces = self.socket.get("get_workspaces")
        self.outputs = self.socket.get("get_outputs")

    def get_workspace_list(self):
        results = []
        for workspace in self.workspaces:
            output = None
            for out in self.outputs:
                if out["name"] == workspace["output"]:
                    output = out
                    break
            if not output:
                continue
            name = workspace["name"]
            if self.monitor and self.monitor == output["name"]:
                results.append((name, self.get_state(workspace, output), output["name"]))
        return results

    def quit(self):
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

