from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible import constants as C
from ansible.playbook.task_include import TaskInclude
from ansible.plugins.callback import CallbackBase
from ansible.utils.color import colorize, hostcolor

class CallbackModule(CallbackBase):

    '''
    This is the default callback interface, which simply prints messages
    to stdout when new callback events are received.
    '''

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'stdout'
    CALLBACK_NAME = 'demo'
    def __init__(self):
        self._play = None
        self._last_task_banner = None
        super(CallbackModule, self).__init__()

    def show(self, task, host, result, caption):
        buf = "="*80 + "\n"
        buf += "{0} \nHOST: {1} \nSTATUS: {2} \nrc={3} >>\n".format(task, host, caption,
                                                                        result.get('rc', 'n/a'))
        buf += "STDOUT: " + result.get('stdout', '') + "\n"
        buf += "STDERR: " + result.get('stderr', '') + "\n"
        buf += "MSG: " + result.get('msg', '') + "\n"
        buf +="\n" + "="*80
        return(buf + "\n")

    def v2_runner_on_failed(self, result, ignore_errors=False):
        #self.show(result._task, result._host.get_name(), result._result, "FAILED")
        delegated_vars = result._result.get('_ansible_delegated_vars', None)
        self._clean_results(result._result, result._task.action)
        self._handle_exception(result._result)
        self._handle_warnings(result._result)
        if result._task.loop and 'results' in result._result:
            self._process_items(result)
        else:
            msg = self.show(result._task, result._host.get_name(), result._result, "FAILED")
            self._display.display(msg, color=C.COLOR_ERROR)
            if ignore_errors:
                self._display.display("...ignoring error\n", color=C.COLOR_SKIP)

    def v2_runner_on_ok(self, result):
        delegated_vars = result._result.get('_ansible_delegated_vars', None)
        self._clean_results(result._result, result._task.action)
        if isinstance(result._task, TaskInclude):
            return
        elif result._result.get('changed', False):
            msg = self.show(result._task, result._host.get_name(), result._result, "CHANGED")
            color=C.COLOR_CHANGED
        else:
            msg = self.show(result._task, result._host.get_name(), result._result, "OK")
            color = C.COLOR_OK
        self._handle_warnings(result._result)
        if result._task.loop and 'results' in result._result:
            self._process_items(result)
        else:
            if (self._display.verbosity > 0 or '_ansible_verbose_always' in result._result) and '_ansible_verbose_override' not in result._result:
                msg += " => %s" % (self._dump_results(result._result),)
            self._display.display(msg, color=color)

    def v2_runner_on_skipped(self, result):
        self.show(result._task, result._host.get_name(), result._result, "SKIPPED")

    def v2_runner_on_unreachable(self, result):
        self.show(result._task, result._host.get_name(), result._result, "UNREACHABLE")
