*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window

Login With Credentials
    [Arguments]    ${username}    ${password}
    Input Text    id=username    ${username}
    Input Text    id=password    ${password}
    Click Button    id=loginBtn
    Wait Until Page Contains Element    id=logoutBtn    timeout=10s

Close Browser
    Close Browser
