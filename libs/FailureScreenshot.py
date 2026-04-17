from robot.libraries.BuiltIn import BuiltIn


class FailureScreenshot:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self._capture_in_progress = False

    def end_keyword(self, data, result):
        if (
            result.status != "FAIL"
            or self._capture_in_progress
            or self._has_failed_child(result)
        ):
            return

        try:
            selenium = BuiltIn().get_library_instance("SeleniumLibrary")
        except Exception:
            return

        try:
            self._capture_in_progress = True
            selenium.capture_page_screenshot()
        except Exception:
            return
        finally:
            self._capture_in_progress = False

    def _has_failed_child(self, result):
        for item in getattr(result, "body", []):
            if getattr(item, "status", None) == "FAIL":
                return True
            if self._has_failed_child(item):
                return True
        return False

