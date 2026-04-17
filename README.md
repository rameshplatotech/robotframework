# Robot Framework Automation

A keyword-driven test automation framework built on Robot Framework, covering UI (Selenium) and API (HTTP) test suites.

---

## Project Structure

```
robotframework/
├── libs/
│   └── FailureScreenshot.py          # Python listener – auto-captures screenshots on failure
├── resources/
│   ├── keywords/
│   │   ├── ui_keywords.robot         # Shared UI keywords (browser, page interactions)
│   │   └── api_keywords.robot        # Shared API keywords (HTTP session, GET/POST)
│   └── variables/
│       └── variables.robot           # Central variable store (URLs, credentials, browser)
├── tests/
│   ├── ui/
│   │   ├── test_gift_card.robot      # UI test – Demo Web Shop gift card flow
│   │   └── test_parabank_login.robot # UI test – Parabank login flow
│   └── api/
│       └── test_api_login.robot      # API test – Dummy REST employee endpoint
├── robot.conf                        # Default Robot CLI options (outputdir, timestamps)
└── requirements.txt                  # Python dependencies
```

---

## How the Framework Is Wired Together

### Variables (`resources/variables/variables.robot`)
Single source of truth for all URLs, credentials, and settings used across both UI and API tests.
Any test file or keyword file pulls these in with:
```robotframework
Resource    ../../resources/variables/variables.robot
```

### UI Keywords (`resources/keywords/ui_keywords.robot`)
Contains all reusable browser-level keywords built on top of `SeleniumLibrary`.
Imports:
- `SeleniumLibrary` with `run_on_failure=Nothing` — disables the default screenshot hook so our custom listener takes full control
- `libs/FailureScreenshot.py` — registers the auto-screenshot listener
- `OperatingSystem` — used to create the screenshots output folder

All UI test files import this resource to get browser control, page interaction, and screenshot behaviour for free.

### API Keywords (`resources/keywords/api_keywords.robot`)
Contains reusable HTTP keywords built on top of `RequestsLibrary`.
Provides:
- `Create API Session` — creates a named HTTP session to a base URL
- `Send GET Request` — sends a GET to an endpoint and returns the response
- `Send POST Request` — sends a POST with a JSON payload and returns the response

All API test files import this resource instead of calling `RequestsLibrary` directly.

### FailureScreenshot (`libs/FailureScreenshot.py`)
A Robot Framework **listener** written in Python. It hooks into every keyword execution and:
1. Detects when a keyword fails at the leaf level (not a parent propagation)
2. Checks if `SeleniumLibrary` is active (only triggers for UI tests)
3. Calls `capture_page_screenshot()` automatically

This means **no changes are needed to test files** — screenshots are attached to `log.html` for every UI failure automatically.

---

## Screenshots

### Automatic – on any UI failure
Every time a UI keyword fails, a screenshot is captured and attached to that step in `log.html` automatically. No setup required.

### Manual – attach at any test step
Call `Attach UI Snapshot` anywhere in a UI test to capture and attach a screenshot on demand:

```robotframework
Attach UI Snapshot                         # uses default label
Attach UI Snapshot    After login loaded   # with a custom label
```

All screenshots are saved under `artifacts/robot/screenshots/` and linked directly in `log.html`.

---

## Run Tests

```powershell
cd path/to/robotframework
robot -A robot.conf tests
```

Run only UI tests:
```powershell
robot -A robot.conf tests/ui
```

Run only API tests:
```powershell
robot -A robot.conf tests/api
```

### Clean and Run

```powershell
Remove-Item -Recurse -Force artifacts -ErrorAction SilentlyContinue
robot -A robot.conf tests
```

### Output Files

All artifacts are written to `artifacts/robot/`:

| File | Description |
|---|---|
| `output-*.xml` | Raw Robot execution data |
| `log-*.html` | Step-by-step execution log with screenshots |
| `report-*.html` | Summary report with pass/fail stats |
| `screenshots/` | UI screenshots (failures + manual snapshots) |

---

## Adding a New UI Test

1. **Add variables** (if needed) to `resources/variables/variables.robot`
2. **Add keywords** for page interactions to `resources/keywords/ui_keywords.robot`
3. **Create a test file** under `tests/ui/`

Minimal template:
```robotframework
*** Settings ***
Resource    ../../resources/variables/variables.robot
Resource    ../../resources/keywords/ui_keywords.robot
Test Teardown    Close Browser Session

*** Test Cases ***
My New UI Test
    Open Browser    ${MY_URL}    ${BROWSER}
    Maximize Browser Window
    # use existing or new keywords from ui_keywords.robot
    Attach UI Snapshot    Page loaded
```

> The `Test Teardown    Close Browser Session` line ensures the browser is closed even if the test fails.
> Auto-screenshots on failure are already active — nothing extra is needed.

---

## Adding a New API Test

1. **Add variables** (if needed) to `resources/variables/variables.robot`
2. **Create a test file** under `tests/api/`

Minimal template:
```robotframework
*** Settings ***
Resource    ../../resources/variables/variables.robot
Resource    ../../resources/keywords/api_keywords.robot

*** Test Cases ***
My New API Test
    Create API Session    alias=myapi    base_url=${MY_API_BASE_URL}
    ${response}=    Send GET Request    /my-endpoint    expected_status=200    alias=myapi
    ${body}=    Evaluate    $response.json()
    Should Be Equal    ${body}[key]    expected_value
```

For POST requests:
```robotframework
    ${payload}=    Create Dictionary    field1=value1    field2=value2
    ${response}=    Send POST Request    /my-endpoint    ${payload}    expected_status=201    alias=myapi
```

> If the API needs custom headers or auth, extend `api_keywords.robot` with a new keyword that calls `Create Session` with the required parameters.
