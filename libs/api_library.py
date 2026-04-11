import requests

class ApiLibrary:
    def __init__(self, base_url):
        self.base_url = base_url

    def get(self, endpoint, **kwargs):
        url = f"{self.base_url}{endpoint}"
        response = requests.get(url, **kwargs)
        response.raise_for_status()
        return response

    def post(self, endpoint, payload=None, **kwargs):
        url = f"{self.base_url}{endpoint}"
        response = requests.post(url, json=payload, **kwargs)
        response.raise_for_status()
        return response
