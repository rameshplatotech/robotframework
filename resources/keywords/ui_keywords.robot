*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
Library    ../../libs/FailureScreenshot.py
Library    OperatingSystem
Resource    ../variables/variables.robot

*** Keywords ***

Close Browser Session
    SeleniumLibrary.Close Browser

Initialize UI Artifacts
    ${screenshot_dir}=    Set Variable    ${OUTPUT DIR}${/}screenshots
    Create Directory    ${screenshot_dir}
    Set Screenshot Directory    ${screenshot_dir}

Attach UI Snapshot
    [Arguments]    ${label}=Manual UI snapshot
    Log    Attaching UI snapshot: ${label}
    Capture Page Screenshot

Open Demo Web Shop Home
    Initialize UI Artifacts
    Open Browser    ${DEMO_WEBSHOP_URL}    ${BROWSER}
    Maximize Browser Window

Open Virtual Gift Card Product Page
    Scroll Element Into View    xpath=//a[normalize-space()='$25 Virtual Gift Card']
    Click Element    xpath=//a[normalize-space()='$25 Virtual Gift Card']/ancestor::div[contains(@class,'product-item')]//input[@value='Add to cart']
    Wait Until Page Contains Element    id=giftcard_2_RecipientName    timeout=10s

Fill Virtual Gift Card Details
    [Arguments]    ${recipient_name}    ${recipient_email}    ${your_name}    ${your_email}    ${message}
    Input Text    id=giftcard_2_RecipientName    ${recipient_name}
    Input Text    id=giftcard_2_RecipientEmail    ${recipient_email}
    Input Text    id=giftcard_2_SenderName    ${your_name}
    Input Text    id=giftcard_2_SenderEmail    ${your_email}
    Input Text    id=giftcard_2_Message    ${message}

Product Name Should Be
    [Arguments]    ${expected_name}
    Element Text Should Be    css=div.product-name h1    ${expected_name}

Open Parabank Home
    Initialize UI Artifacts
    Open Browser    ${PARABANK_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    name=username    timeout=10s

Login To Parabank
    [Arguments]    ${username}    ${password}
    Input Text    name=username    ${username}
    Input Text    name=password    ${password}
    Click Button    xpath=//input[@value='Log In']
    ${login_successful}=    Run Keyword And Return Status    Parabank Login Should Succeed
    IF    not ${login_successful}
        ${login_error_visible}=    Run Keyword And Return Status    Page Should Contain Element    css=p.error
        IF    ${login_error_visible}
            ${login_error}=    Get Text    css=p.error
            Fail    Parabank login failed for user '${username}': ${login_error}
        END
        ${current_url}=    Get Location
        Fail    Parabank login failed for user '${username}'. Expected to reach the Accounts Overview page, but current URL is '${current_url}'.
    END

Parabank Login Should Succeed
    Wait Until Location Contains    overview.htm    timeout=20s
    Wait Until Page Contains    Accounts Overview    timeout=20s

