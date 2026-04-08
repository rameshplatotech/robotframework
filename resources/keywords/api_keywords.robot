*** Settings ***
Library    Collections
Library    RequestsLibrary

*** Variables ***
${LOGIN_ENDPOINT}    /auth/login

*** Keywords ***
Login Via API
    [Arguments]    ${username}    ${password}
    Create Session    api    ${API_BASE_URL}
    ${payload}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    Post Request    api    ${LOGIN_ENDPOINT}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    ${token}=    Get From Dictionary    ${response.json()}    token
    [Return]    ${token}
