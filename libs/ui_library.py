from SeleniumLibrary import SeleniumLibrary

class UiLibrary(SeleniumLibrary):
    def login(self, username, password):
        self.input_text("id=username", username)
        self.input_text("id=password", password)
        self.click_button("id=loginBtn")
        self.wait_until_element_is_visible("id=logoutBtn", timeout=10)
