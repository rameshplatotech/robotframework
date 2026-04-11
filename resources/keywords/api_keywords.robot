*** Settings ***
Library    Collections
Library    RequestsLibrary
Resource    ../variables/variables.robot

*** Keywords ***
Create API Session
    [Arguments]    ${alias}=api    ${base_url}=${API_BASE_URL}
    Create Session    ${alias}    ${base_url}

Send GET Request
    [Arguments]    ${endpoint}    ${expected_status}=any    ${alias}=api
    ${response}=    GET On Session    ${alias}    ${endpoint}    expected_status=${expected_status}
    RETURN    ${response}

Send POST Request
    [Arguments]    ${endpoint}    ${payload}    ${expected_status}=any    ${alias}=api
    ${response}=    POST On Session    ${alias}    ${endpoint}    json=${payload}    expected_status=${expected_status}
    RETURN    ${response}

