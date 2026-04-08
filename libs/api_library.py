import requests

class ApiLibrary:
    def __init__(self, base_url):
        self.base_url = base_url

    def login(self, username, password):
        url = f"{self.base_url}/auth/login"
        payload = {"username": username, "password": password}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        return response.json().get("token")
